class GamesController < BaseController
  require 'net/http'
  require 'uri'
  include Viewable

  protect_from_forgery :only => [:create, :update, :destroy]


  before_filter :login_required, :except => [:index,
                                             :index_open,
                                             :show,
                                             :products,
                                             :private_game,
                                             :sheet,
                                             :notepad,
                                             :update_views,
                                             :play,
                                             :gametable,
                                             :ot_play,
                                             :ot_gametable,
                                             :registration_desk]

  before_filter :valid_game_required, :only => [
      :register_player,
      :register_alternate,
      :choose_pregenerated_character,
      :choose_character,
      :register_pregenerated_character,
      :register_character,
      :show,
      :play,
      :gametable,
      :ot_play,
      :ot_gametable,
      :registration_desk,
      :notepad,
      :update,
      :edit_pregenerated_character_offers,
      :update_pregenerated_character_offers,
      :edit_notepad,
      :update_notepad,
      :d20pro_allow_connections,
      :d20pro_disable_connections,
      :d20pro_launch,
      :new_avatar_photo,
      :private_filter,
      :private_game,
      :products,
      :product_add,
      :product_remove,
      :product_search]

  before_filter :private_filter, :except => [:private_game, :register_player, :register_alternate, :cancel_player, :cancel_alternate, :registration_desk, :index]

  after_filter :expire_game_index_calendar_fragment, :only =>
      [:change_profile_photo,
       :register_player,
       :register_alternate,
       :register_player_for_event,
       :register_alternate_for_event,
       :approve_player,
       :deny_player,
       :cancel_player,
       :cancel_alternate,
       :kick_player,
       :kick_alternate,
       :player_leave_game]

  #auto_complete_for :game, :genre

  uses_tiny_mce do
    {:only => [:new, :create, :update, :edit, :edit_notepad, :welcome_about],
     :options => configatron.default_mce_options.merge({:editor_selector => "rich_text_editor"})}
  end

  uses_tiny_mce do
    {:only => [:show], :options => configatron.simple_mce_options}
  end


  def play
    game = Game.find_by_id(params[:id])
    if game
      @game = game
    else
      flash[:error] = 'Game not found.'
      redirect_to games_url
      return
    end

    logger.debug("GamesController.play")
    # TODO require game owner or active char owner
    @game = Game.find(params[:id])
    @gametable_url = "/games/gametable/#{@game.id}"
    logger.debug("GamesController.play gametable_url=" + @gametable_url)

    render :layout => false

    #render :file => "games/play.html.haml", :layout => false
    #render :file => "games/gametable_standalone.html.erb", :layout => false
  end

  def gametable
    # TODO require game owner or active char owner
    @game = Game.find_by_id(params[:id])

    expire_time = Time.now.to_i + 300
    logger.debug("Expire time " + expire_time.to_s)
    encrypted_time = Digest::SHA1.hexdigest(WOWZA_SECRET_KEY + expire_time.to_s)

    @auth_key = encrypted_time + ":" + expire_time.to_s
    @room_id = @game.room_id
    @room_name = @game.name

    if current_user
      @user_name = current_user.display_name
      @user_id = current_user.login
      @enable_network_god_mode = current_user.enable_network_god_mode
    else
      @user_name = 'guest'
      @user_id = '0'
      @enable_network_god_mode = 'false'
    end

    begin
      render :layout => false
    rescue SocketError
      logger.debug("GamesController.gametable SocketError")
      UserNotifier.game_play_kerfuffle(@game, "SocketError").deliver
      flash[:error] = "Network connection error, SocketError.  Please try again."
      redirect_to :action => "show", :id => params[:id]
    rescue ActiveResource::ResourceNotFound
      logger.debug("GamesController.gametable ActiveResource::ResourceNotFound")
      UserNotifier.game_play_kerfuffle(@game, "ActiveResource::ResourceNotFound").deliver
      flash[:error] = "Game table did not load correctly, ActiveResource::ResourceNotFound. Please try again."
      redirect_to :action => "show", :id => params[:id]
    rescue
      logger.debug("GamesController.gametable other error")
      UserNotifier.game_play_kerfuffle(@game, "other error").deliver
      flash[:error] = "Game table did not load correctly. Please try again."
      redirect_to :action => "show", :id => params[:id]
    end
  end

#  def open
#    game = Game.find(params[:id])
#    if current_user == game.owner
#      game.status = 'open'
#      game.save
#
#      if game.game_system
#        game.game_system.update_game_counts
#      end
#
#      flash[:notice] = 'The registration desk has been opened.'
#    else
#      flash[:error] = 'You may not edit games you do not own.'
#    end
#    redirect_to :action => "show", :id => params[:id]
#  end
#
#  def close
#    game = Game.find(params[:id])
#    if current_user == game.owner
#      game.status = 'closed'
#      game.save
#
#      if game.game_system
#        game.game_system.update_game_counts
#      end
#
#      flash[:notice] = 'The registration desk has been closed.'
#    else
#      flash[:error] = 'You may not edit games you do not own.'
#    end
#    redirect_to :action => "show", :id => params[:id]
#  end


# START - Player registration

  def register_player
    game = Game.find_by_id(params[:id])

    if game.slots.any?
      flash[:error] = 'This game is part of an event. Registration must be done through the event.'
      redirect_to event_path(game.slots.last.event)
      return
    end

    if game && game.status == 'open' && game.active_players.size < game.player_seats
      playerRegistration = PlayerRegistration.new
      game.player_registrations << playerRegistration
      current_user.player_registrations << playerRegistration

      if game.auto_approve_player_registrations
        playerRegistration.status = 'active'
        playerRegistration.save
        UserNotifier.game_approve_player_notice(playerRegistration.game, playerRegistration).deliver
        UserNotifier.game_join_player_auto_approved_notice(game, playerRegistration).deliver
      else
        playerRegistration.status = 'pending'
        playerRegistration.save
        UserNotifier.game_join_player_notice(game, playerRegistration).deliver
      end

    else
      if game.status == 'open' && game.alternate_players.size < game.alternate_seats
        flash[:error] = 'Game is full. Alternate seats are available.'
      else
        flash[:error] = 'Game is full.'
      end
    end

    redirect_to :action => 'registration_desk', :id => params[:id]
  end


  def register_alternate
    game = Game.find_by_id(params[:id])

    if game.slots.any?
      flash[:error] = 'This game is part of an event. Registration must be done through the event.'
      redirect_to event_path(game.slots.last.event)
      return
    end


    if game && game.status == 'open' && game.alternate_players.size < game.alternate_seats
      playerRegistration = PlayerRegistration.new
      game.player_registrations << playerRegistration
      current_user.player_registrations << playerRegistration

      playerRegistration.status = 'alternate'
      playerRegistration.save

      alternate_position = game.alternate_position(current_user)

      UserNotifier.game_join_alternate_notice(game, playerRegistration).deliver
      UserNotifier.game_approve_alternate_notice(playerRegistration.game, playerRegistration, alternate_position).deliver
    else
      flash[:error] = 'Game is not open for registration.'
    end

    redirect_to :action => 'registration_desk', :id => params[:id]
  end

  def register_player_for_event
    game = Game.find_by_id(params[:id])
    slot = Slot.find_by_id(params[:slot_id])

    if slot.event.is_registering_premium_players && current_user.membership_level < 2
      flash[:error] = 'Early registration is available for Exalted members. Upgrade today!'
      redirect_to event_path(slot.event)
      return
    end

    # Any event edit will affect game.status, so we can trust that open means open

    if game && game.status == 'open' && game.active_players.size < game.player_seats
      playerRegistration = PlayerRegistration.new
      game.player_registrations << playerRegistration
      current_user.player_registrations << playerRegistration

      if game.auto_approve_player_registrations
        playerRegistration.status = 'active'
        playerRegistration.save
        UserNotifier.game_approve_player_notice(playerRegistration.game, playerRegistration).deliver
        UserNotifier.game_join_player_auto_approved_notice(game, playerRegistration).deliver
      else
        playerRegistration.status = 'pending'
        playerRegistration.save
        UserNotifier.game_join_player_notice(game, playerRegistration).deliver
      end
    else
      flash[:error] = 'Game is not open for registration.'
    end

    redirect_to event_path(slot.event)
  end

  def register_alternate_for_event
    game = Game.find_by_id(params[:id])
    slot = Slot.find_by_id(params[:slot_id])

    if slot.event.is_registering_premium_players && current_user.membership_level < 2
      flash[:error] = 'Early registration is available for Exalted members. Upgrade today!'
      redirect_to event_path(slot.event)
      return
    end

    # Any event edit will affect game.status, so we can trust that open means open

    if game && game.status == 'open' && game.alternate_players.size < game.alternate_seats
      playerRegistration = PlayerRegistration.new
      game.player_registrations << playerRegistration
      current_user.player_registrations << playerRegistration

      playerRegistration.status = 'alternate'
      playerRegistration.save

      alternate_position = game.alternate_position(current_user)

      UserNotifier.game_join_alternate_notice(game, playerRegistration).deliver
      UserNotifier.game_approve_alternate_notice(playerRegistration.game, playerRegistration, alternate_position).deliver
    else
      flash[:error] = 'Game is not open for registration.'
    end

    redirect_to event_path(slot.event)
  end


  def approve_player
    playerRegistration = PlayerRegistration.fetch(params[:id], params[:user_id], 'pending')

    if playerRegistration && current_user == playerRegistration.game.owner
      playerRegistration.activate!
      playerRegistration.character_registrations.each do |character_registration|
        character_registration.activate!
      end
      UserNotifier.game_approve_player_notice(playerRegistration.game, playerRegistration).deliver
    else
      flash[:error] = 'You may not approve registrations for a game you do not own.'
    end

    redirect_to :action => 'registration_desk', :id => params[:id]
  end

  def deny_player
    playerRegistration = PlayerRegistration.find_by_game_id_and_user_id_and_status(params[:id], params[:user_id], 'pending')

    if playerRegistration && current_user == playerRegistration.game.owner
      UserNotifier.game_deny_player_notice(playerRegistration.game, playerRegistration).deliver
      playerRegistration.destroy
    else
      flash[:error] = 'You may not deny registrations for a game you do not own.'
    end

    redirect_to :action => 'registration_desk', :id => params[:id]
  end

  def cancel_player
    playerRegistration = PlayerRegistration.fetch(params[:id], params[:user_id], 'pending')

    if playerRegistration && current_user == playerRegistration.user
      UserNotifier.game_cancel_player_notice(playerRegistration.game, playerRegistration).deliver
      playerRegistration.destroy
    else
      flash[:error] = 'You may not cancel a registration you do not own.'
    end

    redirect_to :action => 'registration_desk', :id => params[:id]
  end

  def cancel_alternate
    playerRegistration = PlayerRegistration.fetch(params[:id], params[:user_id], 'alternate')

    if playerRegistration && current_user == playerRegistration.user
      UserNotifier.game_cancel_player_notice(playerRegistration.game, playerRegistration).deliver
      playerRegistration.destroy
    else
      flash[:error] = 'You may not cancel a registration you do not own.'
    end

    redirect_to :action => 'registration_desk', :id => params[:id]
  end

  def kick_player
    @game = Game.find_by_id(params[:id])
    playerRegistration = PlayerRegistration.find_by_game_id_and_user_id_and_status(params[:id], params[:user_id], 'active')

    if playerRegistration && @game && current_user == playerRegistration.game.owner
      UserNotifier.game_kick_player_notice(playerRegistration.game, playerRegistration).deliver
      playerRegistration.destroy

      if @game.alternate_players.size > 0
        alternateRegistration = PlayerRegistration.find_by_game_id_and_user_id_and_status(params[:id], @game.alternate_players.first.id, 'alternate')
        if alternateRegistration
          alternateRegistration.activate!
          UserNotifier.game_activate_alternate_notice(alternateRegistration.game, alternateRegistration).deliver
        end
      end

    else
      flash[:error] = 'You may not kick players from a game you do not own.'
    end

    redirect_to :action => 'registration_desk', :id => params[:id]
  end

  def kick_alternate
    @game = Game.find_by_id(params[:id])
    playerRegistration = PlayerRegistration.find_by_game_id_and_user_id_and_status(params[:id], params[:user_id], 'alternate')

    if playerRegistration && @game && current_user == playerRegistration.game.owner
      UserNotifier.game_kick_alternate_notice(playerRegistration.game, playerRegistration).deliver
      playerRegistration.destroy
    else
      flash[:error] = 'You may not kick players from a game you do not own.'
    end

    redirect_to :action => 'registration_desk', :id => params[:id]
  end

  def player_leave_game
    @game = Game.find_by_id(params[:id])
    playerRegistration = PlayerRegistration.find_by_game_id_and_user_id_and_status(params[:id], params[:user_id], 'active')

    if playerRegistration && @game && current_user == playerRegistration.user

      if @game.alternate_players.size > 0
        alternateRegistration = PlayerRegistration.find_by_game_id_and_user_id_and_status(params[:id], @game.alternate_players.first.id, 'alternate')
        if alternateRegistration
          alternateRegistration.activate!
          UserNotifier.game_activate_alternate_notice(alternateRegistration.game, alternateRegistration).deliver
          UserNotifier.game_player_leave_and_alternate_activated_notice(playerRegistration.game, playerRegistration, alternateRegistration).deliver
        end
      end

      UserNotifier.game_player_leave_notice(playerRegistration.game, playerRegistration).deliver
      playerRegistration.destroy
    else
      flash[:error] = 'You may not cancel registrations you do not own.'
    end

    redirect_to :action => 'registration_desk', :id => params[:id]
  end

  # END - Player registration


  #def deny_pregenerated
  #  pregeneratedCharacterRequest = PregeneratedCharacterRequest.fetch(params[:character_id], params[:id], params[:user_id])
  #
  #  if !pregeneratedCharacterRequest.nil? && current_user == pregeneratedCharacterRequest.game.owner
  #    UserNotifier.game_deny_pregenerated_notice(pregeneratedCharacterRequest.game, pregeneratedCharacterRequest).deliver
  #    pregeneratedCharacterRequest.destroy
  #  else
  #    flash[:error] = 'You may not deny registrations for a game you do not own.'
  #  end
  #
  #  redirect_to :action => 'join', :id => params[:id]
  #end

  #def cancel_character
  #  registration = CharacterRegistration.fetch(params[:character_id], params[:id], 'pending')
  #
  #  if registration && current_user == registration.character.owner
  #    registration.destroy
  #  else
  #    flash[:error] = 'You may not cancel a registration for a character you do not own.'
  #  end
  #
  #  redirect_to :action => 'join', :id => params[:id]
  #end

  #def cancel_pregenerated
  #  pregeneratedCharacterRequest = PregeneratedCharacterRequest.fetch(params[:character_id], params[:id], current_user.id)
  #
  #  if !pregeneratedCharacterRequest.nil? && current_user == pregeneratedCharacterRequest.owner
  #    pregeneratedCharacterRequest.destroy
  #  else
  #    flash[:error] = 'You may not cancel a registration you do not own.'
  #  end
  #
  #  redirect_to :action => 'join', :id => params[:id]
  #end

  def system_cateogry_search
    redirect_to :controller => "system_categories", :action => "index", :new_game => true
  end

  def choose_pregenerated_character
    @game = Game.find(params[:id])
  end

  def choose_character
    @game = Game.find(params[:id])

    @eligible_characters = []
    @ineligible_characters = []
    @my_characters = current_user.characters

    @game.character_registrations.each do |registration|
      character = Character.find_by_id(registration.character_id)

      if @my_characters.include?(character)
        @ineligible_characters << character
      end
    end

    if !@my_characters.nil? && !@ineligible_characters.nil?
      @eligible_characters = @my_characters - @ineligible_characters
    end
  end

  def register_pregenerated_character
    @game = Game.find(params[:id])
    pregenChar = Character.find_by_id(params[:character_id])
    playerRegistration = PlayerRegistration.find_by_game_id_and_user_id(params[:id], current_user.id)

    if @game && pregenChar && current_user && playerRegistration
      character = pregenChar.get_clone(current_user)
      character.associate_products_from_game(@game)

      characterRegistration = CharacterRegistration.new
      @game.character_registrations << characterRegistration
      character.character_registrations << characterRegistration
      characterRegistration.status = playerRegistration.status
      playerRegistration.character_registrations << characterRegistration

      if characterRegistration.status == 'active'
        UserNotifier.game_register_pregenerated_character_notice(@game, characterRegistration).deliver
      end
    else
      flash[:error] = 'You may not register a pregenerated character for a game you are not registered in.'
    end

    redirect_to :action => 'registration_desk', :id => params[:id]
  end

  def register_character
    @game = Game.find(params[:id])
    character = Character.find_by_id(params[:character_id])
    playerRegistration = PlayerRegistration.find_by_game_id_and_user_id(params[:id], current_user.id)

    if current_user && @game && character && playerRegistration
      characterRegistration = CharacterRegistration.new
      characterRegistration.status = playerRegistration.status
      @game.character_registrations << characterRegistration
      character.character_registrations << characterRegistration
      playerRegistration.character_registrations << characterRegistration

      character.associate_products_from_game(@game)

      if characterRegistration.status == 'active'
        UserNotifier.game_register_character_notice(@game, characterRegistration).deliver
      end

      character.is_private = @game.is_private
      character.save

    else
      flash[:error] = 'You may not register a character you do not own.'
    end

    redirect_to :action => 'registration_desk', :id => params[:id]
  end

  def register_new_character
    redirect_to :action => 'new', :controller => 'characters', :auto_register_game_id => params[:id]
  end

  def character_leave_game
    @game = Game.find(params[:id])
    characterRegistration = CharacterRegistration.find_by_game_id_and_character_id(params[:id], params[:character_id])

    if characterRegistration && current_user == characterRegistration.character.owner

      if characterRegistration.status == 'active'
        UserNotifier.game_character_leave_notice(characterRegistration.game, characterRegistration).deliver
      end

      characterRegistration.destroy
    else
      flash[:error] = 'You may not cancel registrations you do not own.'
    end

    redirect_to :action => 'registration_desk', :id => params[:id]
  end

  def kick_character
    characterRegistration = CharacterRegistration.find_by_game_id_and_character_id(params[:id], params[:character_id])

    if characterRegistration && current_user == characterRegistration.game.owner
      UserNotifier.game_kick_character_notice(characterRegistration.game, characterRegistration).deliver
      characterRegistration.destroy
    else
      flash[:error] = 'You may not kick characters from a game you do not own.'
    end

    redirect_to :action => 'registration_desk', :id => params[:id]
  end

  def release_alternates
    @game = Game.find(params[:id])

    if @game && current_user && @game.owner == current_user
      @game.alternate_players.each do |alternate|
        alternateRegistration = PlayerRegistration.find_by_game_id_and_user_id_and_status(params[:id], alternate.id, 'alternate')
        if alternateRegistration
          UserNotifier.game_release_alternates_notice(alternateRegistration.game, alternateRegistration).deliver
          alternateRegistration.destroy
        end
      end
    else
      flash[:error] = 'You may not release alternates for game you do not own.'
    end

    redirect_to :action => 'registration_desk', :id => params[:id]
  end

  # END - Character registration


  # GET /games
  # GET /games.xml
  def index
    if params[:system_name] && GameSystem.find_by_name(params[:system_name])
      # valid system name: works by design
    elsif params[:system_name].blank?
      # blank system name: params[:system_name] needs to be removed
      # This prevents 'system_name_id = <blank name game_system.id>' from being generated
      params.delete(:system_name)
    else
      # invalid system name: needs to redirect to game system page
      flash[:notice] = "No results for '#{params[:system_name]}'. These are the game systems we know about."
      redirect_to game_systems_path
      return
    end

    #if params[:name].nil? && params[:status].nil?
    #  params[:status] = 'open'
    #end

    game_system_id = 0
    if !params[:system_name].blank?
      gameSystem = GameSystem.find_by_name(params['system_name'])
      game_system_id = gameSystem.id
    end

    @no_search_criteria = false
    if (params[:system_name].blank? && params[:genre].blank? && params[:name].blank? && params[:status].blank? && params[:is_d20pro].blank?)
      @no_search_criteria = true
    end

    games, @search, @metro_areas, @states = Game.search_conditions_with_metros_and_states(params, game_system_id)

    @result_header = games.size.to_s
    @games = games.recent.page(params[:page]).per(25)

    if !params[:status].blank? && params[:status]
      @result_header += ' open'
    end

    if !params[:system_name].blank?
      @result_header += ' ' + params[:system_name]
    end

    if !params[:is_d20pro].blank?
      @result_header += ' d20Pro '
    end

    if @games.size == 1
      @result_header += ' game'
    else
      @result_header += ' games'
    end

    # For _game_system partial
    @game_systems = GameSystem.where("open_game_count > 0 and name != ''").order('open_game_count DESC, name').limit(10)
    @game_system_count = GameSystem.where("open_game_count > 0 and name != ''").count
    @open_game_count = Game.where('status = "open"').count

    if games.where_sql.blank? # No search criteria
      calendar_conditions = '1'
    else
      calendar_conditions = games.where_sql.sub(/^WHERE/i, '')
    end


    @month = (params[:month] || Time.zone.now.month).to_i
    @year = (params[:year] || Time.zone.now.year).to_i
    @shown_month = Date.civil(@year, @month)
    @event_strips = Game.event_strips_for_month(@shown_month, :conditions => calendar_conditions)

    @game_index_calendar_cache_fragment_suffix = "PacificTimeUSCanada"
    if current_user
      @game_index_calendar_cache_fragment_suffix = current_user.time_zone.gsub(/\W/, '')
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @games }
    end
  end


  # GET /games/1
  # GET /games/1.xml
  def show
    begin
      @game = Game.find(params[:id])
    rescue
      flash[:error] = 'Game not found.'
      redirect_to games_url
      return
    end

    @comments = @game.comments.order('created_at ASC').limit(200)

    @posts = @game.posts.recent.limit(5)
    #@popular_posts = @category.posts.find(:all, :limit => 10, :order => "view_count DESC")
    #@popular_polls = Poll.find_popular_in_category(@category)
    #@rss_title = "#{configatron.community_name}: #{@category.name} "+:posts.l
    #@rss_url = category_path(@category, :format => :rss)


    @system_announcement = Post.all(:conditions => ["is_game_announcement = true"], :order => "updated_at desc", :limit => 1)


    @character_blog_posts = []
    @game.active_characters.each do |active_character|
      logger.debug("GamesController.show active_character=" + active_character.name)
      if active_character.posts.recent.first && active_character.posts.recent.first.is_live?
        logger.debug("GamesController.show active_character.posts.recent.first=" + active_character.posts.recent.first.title)
        @character_blog_posts << active_character.posts.recent.first
      end
    end

    if @game.room_id.nil? || @game.room_id == 0
      @game.room_id = fetchRoomId()
      @game.save
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @game }
    end
  end


  # GET /games/1/join
  # def join
  # @game = Game.find(params[:id])
  #
  # @pending_characters = @game.pending_characters
  # @active_characters = @game.active_characters
  #
  # @active_players = @game.active_players
  # @pending_players = @game.pending_players
  #
  # @eligible_characters = []
  # @ineligible_characters = []
  # @my_characters = current_user.characters
  #
  # @game.character_registrations.each do |registration|
  # character = Character.find_by_id(registration.character_id)
  #
  # if @my_characters.include?(character)
  # @ineligible_characters << character
  # end
  # end
  #
  # if !@my_characters.nil? && !@ineligible_characters.nil?
  # @eligible_characters = @my_characters - @ineligible_characters
  # end
  #
  # respond_to do |format|
  # format.html # join.html.erb
  # end
  # end


  def registration_desk
    @game = Game.find(params[:id])

    @pending_characters = @game.pending_characters
    @active_characters = @game.active_characters

    @pending_players = @game.pending_players
    @active_players = @game.active_players

    @eligible_characters = []
    @ineligible_characters = []
    @my_characters = []

    if current_user
      @my_characters = current_user.characters
    end

    @game.character_registrations.each do |character_registration|
      character = Character.find_by_id(character_registration.character_id)

      if @my_characters.include?(character)
        @ineligible_characters << character
      end
    end

    if !@my_characters.nil? && !@ineligible_characters.nil?
      @eligible_characters = @my_characters - @ineligible_characters
    end

    respond_to do |format|
      format.html
    end
  end

  def notepad
    @game = Game.find(params[:id])

    respond_to do |format|
      format.html # notepad.html.erb
      format.xml { render :xml => @character }
    end
  end

  # GET /games/new
  # GET /games/new.xml
  def new
    @game = current_user.games.new
    @game.start_at = Time.now
    @game.status = 'open'
    @game.session_length = '4 hours'
    @game.player_seats = 3
    @game.d20pro_ip = request.remote_ip
    @game.name = current_user.display_name + "'s game"

    if params[:system_category_id]
      @system_category_id = params[:system_category_id]
      system_category = SystemCategory.find_by_id(params[:system_category_id])
      if system_category
        @game.name = current_user.display_name + "'s " + system_category.name + " game"
        system_category.products.each do |product|
          @game.add_product(product)
        end
      end
    end

    if params[:product_id]
      @product_id = params[:product_id]
      product = Product.find_by_id(params[:product_id])
      if product
        @game.name = current_user.display_name + "'s " + product.name + " game"
        @game.add_product(product)
      end
    end

    if params[:register_slot_id]
      @register_slot_id = params[:register_slot_id]

      slot = Slot.find(params[:register_slot_id])
      if slot
        # Assume that games for events should be open for registration
        @game.status = 'open'
        @game.alternate_seats = EVENT_ALTERNATE_SEATS
        @game.start_at = slot.start_time
        @game.end_at = slot.start_time + 1
        @game.session_length = ((slot.end_time - slot.start_time) / 1.hour).to_i.to_s + ' hours'
      end
    end


    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @game }
    end
  end


  # POST /games
  # POST /games.xml
  def create
    attributes = {}
    if game_params
      attributes = game_params.permit!
    end
    @game = current_user.games.new(attributes)
    @game.room_id = fetchRoomId

    # This has issues with case, resulting in dupes of the same tag
    #@game.tag_list = params[:game][:system]  + ", " + params[:tag_list]
    @game.tag_list = params[:tag_list]

    @game.status = 'open'

    @game.start_at = params[:game][:start_at]
    if @game.start_at
      @game.end_at = @game.start_at + 1
    end

    respond_to do |format|
      if @game.save

        expire_game_index_calendar_fragment(@game)

        if params[:system_category_id]
          @system_category_id = params[:system_category_id]
          system_category = SystemCategory.find_by_id(params[:system_category_id])
          if system_category
            system_category.products.each do |product|
              @game.add_product(product)
            end
          end
        end


        if params[:product_id]
          @product_id = params[:product_id]
          product = Product.find_by_id(params[:product_id])
          if product
            @game.add_product(product)
          end
        end

        #if @game.game_system
        #  @game.game_system.update_game_counts
        #end

        if !params[:register_slot_id].blank?
          slot = Slot.find(params[:register_slot_id])
          if slot && @game && slot.event.is_registering_games
            slotGameRegistration = SlotGameRegistration.new
            slot.slot_game_registrations << slotGameRegistration
            @game.slot_game_registrations << slotGameRegistration
            slotGameRegistration.status = 'pending'
            slotGameRegistration.save

            @game.updateWithSlotInfo(slot)
            @game.save

            UserNotifier.slot_register_game_notice(slotGameRegistration).deliver

            flash[:notice] = "#{@game.name} has been registered.".html_safe

            redirect_to event_path(slotGameRegistration.slot.event)
            return
          else
            flash[:error] = 'Event is not open for registration.'
          end
        end

        flash[:notice] = 'Game was successfully created.'

        # TODO: Make this a daily newsletter
        #UserNotifier.new_game_notice(@game).deliver

        format.html { redirect_to seo_game_path(@game) }
        format.xml { render :xml => @game, :status => :created, :location => @game }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @game.errors, :status => :unprocessable_entity }
      end
    end
  end


  # PUT /games/1
  # PUT /games/1.xml
  def update
    @game = Game.find(params[:id])

    if current_user && (current_user == @game.owner || current_user.admin?)


      # This has issues with case, resulting in dupes of the same tag
      #@game.tag_list = params[:game][:system]  + ", " + params[:tag_list]
      @game.tag_list = params[:tag_list]

      old_month = @game.start_at.month
      old_year = @game.start_at.year
      old_day = @game.start_at.day
      old_hour = @game.start_at.hour

      @game.start_at = params[:game][:start_at]
      if @game.start_at
        @game.end_at = @game.start_at + 1
      end

      slot = @game.slots.last
      if slot
        if slot.event.is_registering_regular_players || slot.event.is_registering_premium_players
          params[:game][:status] = 'open'
        else
          params[:game][:status] = 'closed'
        end
        params[:game][:auto_approve_player_registrations] = true
        params[:game][:alternate_seats] = EVENT_ALTERNATE_SEATS
        params[:game][:start_at] = slot.start_time
        params[:game][:end_at] = slot.start_time + 1
        params[:game][:session_length] = ((slot.end_time - slot.start_time) / 1.hour).to_i.to_s + ' hours'
      end

      respond_to do |format|
        if @game.update_attributes(game_params)

          if @game.characters.any? && @game.products.any?
            @game.products.each do |product|
              @game.characters.each do |character|
                character.add_product(product)
              end
            end
          end

          if @game.game_system
            @game.game_system.update_game_counts
          end

          if old_month != @game.start_at.month ||
              old_year != @game.start_at.year ||
              old_day != @game.start_at.day ||
              old_hour != @game.start_at.hour

            cache_fragment_match = "game_index_calendar_" + old_month.to_s + "_" + old_year.to_s + ".*"
            expire_fragment(/#{cache_fragment_match}/)

            expire_game_index_calendar_fragment(@game)
          end

          flash[:notice] = 'Game was successfully updated.'
          format.html { redirect_to(@game) }
          format.xml { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml { render :xml => @game.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # GET /games/1/edit
  def edit_name
    @game = Game.find(params[:id])
    if @game && (@game.owner == current_user || current_user.admin?)
      return @game
    else
      flash[:error] = 'You may not edit games you do not own.'
      redirect_to user_path(current_user)
    end
  end

  # GET /games/1/edit
  def edit
    @game = Game.find(params[:id])
    if @game && (@game.owner == current_user || current_user.admin?)
      return @game
    else
      flash[:error] = 'You may not edit games you do not own.'
      redirect_to user_path(current_user)
    end
  end

  def edit_clone
    original = Game.find(params[:id])

    if original.others_can_clone || current_user == original.owner
      @game = original.get_clone(current_user)

      current_user.games << @game
      redirect_to edit_game_path(@game)
      return
    end

    redirect_to seo_game_path(@game)
  end


  # DELETE /games/1
  # DELETE /games/1.xml
  def destroy
    @game = Game.find(params[:id])

    if !(@game.owner == current_user || current_user.admin?)
      flash[:error] = 'You may not delete a game you do not own.'
      redirect_to(games_url)
    end

    expire_game_index_calendar_fragment()

    @game.destroy

    @month = Time.zone.now.month
    @year = Time.zone.now.year

    respond_to do |format|
      format.html { redirect_to(games_url) }
      format.xml { head :ok }
    end
  end

  def edit_pregenerated_character_offers
    @game = current_user.games.find(params[:id])

    @offered_pregenerated_characters = []
    @game.pregenerated_character_offers.each do |pco|
      @offered_pregenerated_characters << pco.character
    end

    @available_pregenerated_characters = []
    current_user.characters.each do |character|
      if !@offered_pregenerated_characters.include?(character)
        @available_pregenerated_characters << character
      end
    end
  end

  def update_pregenerated_character_offers
    @game = current_user.games.find(params[:id])

    create_pregenerated_character_offers(@game, params[:offer])
    revoke_pregenerated_character_offers(@game, params[:revoke])

    redirect_to edit_pregenerated_character_offers_path(@game)
  end

  def create_pregenerated_character_offers(game, offers)
    if !offers.nil?
      offers.each do |offer|
        if offer.last == "1" # Is the checkbox checked?
          character = Character.find(offer.first)
          alreadyOffered = PregeneratedCharacterOffer.fetch(offer.first, game.id)
          if alreadyOffered.nil?
            pregeneratedCharacterOffer = PregeneratedCharacterOffer.new
            game.pregenerated_character_offers << pregeneratedCharacterOffer
            character.pregenerated_character_offers << pregeneratedCharacterOffer
            pregeneratedCharacterOffer.save
            logger.debug "create_pregenerated_character_offers just saved #{pregeneratedCharacterOffer.character_id}"
          end
        end
      end
    end
  end

  def revoke_pregenerated_character_offers(game, revokes)
    if !revokes.nil?
      revokes.each do |revoke|
        if revoke.last == "1" # Is the checkbox checked?
          pregeneratedCharacterOffer = PregeneratedCharacterOffer.fetch(revoke.first, game.id)
          pregeneratedCharacterOffer.destroy
          logger.debug "create_pregenerated_character_offers just saved #{pregeneratedCharacterOffer.character_id}"
        end
      end
    end
  end

  def edit_notepad
    @game = Game.find(params[:id])
    if @game && (@game.owner == current_user || current_user.admin?)
      return @game
    else
      flash[:error] = 'You may not edit game notepads you do not own.'
      redirect_to user_path(current_user)
    end
  end

  def update_notepad
    @game = current_user.games.find(params[:id])

    respond_to do |format|
      attributes = game_params.permit!
      if @game.update_attributes(attributes)
        flash[:notice] = 'Game notepads were successfully updated.'
        format.html { redirect_to(@game) }
        format.xml { head :ok }
      else
        format.html { render :action => "edit_notepad" }
        format.xml { render :xml => @character.errors, :status => :unprocessable_entity }
      end
    end
  end

  def change_profile_photo
    @game = current_user.games.find(params[:id])

    # TODO make this a before_filter
    if current_user != @game.owner
      flash[:error] = "You may not edit this game."
      redirect_to seo_game_path(@game)
      return
    end

    @photo = Photo.find(params[:photo_id])
    @game.avatar = @photo

    if @game.save!
      flash[:notice] = 'Game was successfully updated.'
      redirect_to seo_game_path(@game)

      @photo.is_private = @game.is_private
      @game.save!

    else
      format.html { render :action => "edit" }
    end
  rescue ActiveRecord::RecordInvalid
    render :action => 'edit'
  end

  def pick_profile_photo
    @game = current_user.games.find(params[:id])

    # TODO make this a before_filter
    if current_user != @game.owner
      flash[:error] = "You may not edit this game."
      redirect_to seo_game_path(@game)
      return
    end

    @user = @game.owner
    @photos = @user.photos.recent.page(params[:page]).per(100)


    #@tags = Photo.tag_counts :conditions => { :user_id => @user.id }, :limit => 20

    @rss_title = "#{configatron.community_name}: #{@user.login}'s photos"
    @rss_url = user_photos_path(@user, :format => :rss)

    respond_to do |format|
      format.html # index.rhtml
      format.rss {
        render_rss_feed_for(@photos,
                            {:feed => {:title => @rss_title, :link => url_for(:controller => 'photos', :action => 'index', :user_id => @user)},
                             :item => {:title => :name,
                                       :description => Proc.new { |photo| description_for_rss(photo) },
                                       :link => Proc.new { |photo| user_photo_url(photo.user, photo) },
                                       :pub_date => :created_at}})

      }
      format.xml { render :action => 'index.rxml', :layout => false }
    end
  end

  def update_views
    if logged_in?
      @game = Game.find(params[:id])
      updated = update_view_count(@game)
      render :text => updated ? 'updated' : 'duplicate'
      return
    end

    # not really a dup, but this isn't displayed anyway
    render :text => 'duplicate'
  end

  def reset_game_table
    @game = Game.find(params[:id])
    if @game && (current_user.admin? || current_user == @game.owner)
      old_room_id = @game.room_id
      @game.room_id = fetchRoomId
      @game.save

      logger.info "Game table reset: game_id=#{@game.id}, reset by #{current_user.display_name}, old_room_id=#{old_room_id}, new room_id=#{@game.room_id}"
      UserNotifier.game_table_reset(@game, current_user, old_room_id).deliver

      flash[:notice] = "old room id: #{old_room_id}, new room id: #{@game.room_id}"
      redirect_to seo_game_path(@game)
    end
  end

  def fetchRoomId
    # TODO: run this under https, and pass credentials via post
    begin
      res = Net::HTTP.post_form(URI.parse(ROOM_ID_SERVER + '/services/newRoomId'), {'username' => 'muldoon', 'password' => 'a2eaff9f7e6e3241e44f3360a47eefda'})
      return res.body
    rescue
      return nil
    end
  end


  def d20pro_allow_connections
    @game = current_user.games.find(params[:id])
    if current_user == @game.owner
      @game.d20pro_ready_to_play = true
      @game.save
      redirect_to seo_game_path(@game)
    end
  end

  def d20pro_disable_connections
    @game = current_user.games.find(params[:id])
    if current_user == @game.owner
      @game.d20pro_ready_to_play = false
      @game.save
      redirect_to seo_game_path(@game)
    end
  end

  def d20pro_launch
    @game = Game.find(params[:id])
    if @game.active_players.include?(current_user) || current_user == @game.owner
      respond_to do |format|
        format.xml do

          name = current_user.first_name + " " + current_user.last_name
          @d20pro_alias= name.gsub(/[^a-zA-Z0-9]/, '_')
          stream = render_to_string(:template => "games/d20pro_launch.xml.builder")
          send_data(stream, :type => "application/x-d20pro", :filename => "launch.d20pro")
        end
        format.prp do
          stream = render_to_string(:template => "games/d20pro_launch.prp")
          send_data(stream, :type => "text/plain", :filename => "launch.d20pro")
        end
      end
    else
      flash[:notice] = "You are not allowed to connect to games you are not registered in."
      redirect_to seo_game_path(@game)
    end
  end

  def top_open_games(limit = nil)
    GameSystem.find(:all, :conditions => "open_game_count > 0 and name != ''", :order => 'open_game_count DESC, name')
  end

  def new_avatar_photo
    @game = Game.find(params[:id])

    if @game && (current_user.admin? || current_user == @game.owner)
      @photo = Photo.new
    else
      flash[:notice] = "You are not allowed to modify a game you do not own."
      redirect_to seo_game_path(@game)
    end
  end


  def ot_play
    @game = Game.find_by_id(params[:id])
    if @game.nil?
      flash[:error] = 'Game not found.'
      redirect_to games_url
      return
    end

    expire_time = Time.now.to_i + 300
    encrypted_time = Digest::SHA1.hexdigest(WOWZA_SECRET_KEY + expire_time.to_s)

    @auth_key = encrypted_time + ":" + expire_time.to_s
    @room_id = @game.room_id
    @room_name = @game.name

    @user_name = 'guest'
    @user_id = '0'
    @enable_network_god_mode = 'false'
    @video_background_image = APP_URL + configatron.photo.missing_thumb.to_s
    if current_user
      @user_name = current_user.display_name
      @user_id = current_user.login
      @enable_network_god_mode = current_user.enable_network_god_mode
    end

    if @game.opentok_session_id.blank?
      @game.set_opentok_session(request.remote_addr)
    end

    #opentok = OpenTok::OpenTokSDK.new OPENTOK_API_KEY, OPENTOK_API_SECRET
    #@opentok_session_id = @game.opentok_session_id
    #@opentok_token = opentok.generate_token :session_id => @ot_session_id, :role => OpenTok::RoleConstants::PUBLISHER, :connection_data => "username=#{@user_name},level=4"


    render :layout => false
  end

  def ot_gametable
    # TODO require game owner or active char owner
    @game = Game.find_by_id(params[:id])

    expire_time = Time.now.to_i + 300
    logger.debug("Expire time " + expire_time.to_s)
    encrypted_time = Digest::SHA1.hexdigest(WOWZA_SECRET_KEY + expire_time.to_s)

    @auth_key = encrypted_time + ":" + expire_time.to_s
    @room_id = @game.room_id
    @room_name = @game.name

    if current_user
      @user_name = current_user.display_name
      @user_id = current_user.login
      @enable_network_god_mode = current_user.enable_network_god_mode
    else
      @user_name = 'guest'
      @user_id = '0'
      @enable_network_god_mode = 'false'
    end

    render :layout => false
  end

  def expire_game_index_calendar_fragment(game=nil)
    if game.nil?
      game = Game.find(params[:id])
    end

    cache_fragment_match = "game_index_calendar_" + game.start_at.month.to_s + "_" + game.start_at.year.to_s + ".*"
    expire_fragment(/#{cache_fragment_match}/)
  end

  def products
    @game = Game.find_by_id(params[:id])
    @comments = @game.comments.order('created_at ASC').limit(200)
  end

  #def product_search
  #  #@game = Game.find_by_id(params[:id])
  #
  #  #@search = {}.merge(params)
  #  #@search['name'] =  params[:name]
  #  #
  #  #@products = []
  #  #@popular_products = []
  #  #
  #  #if @search['name'].blank?
  #  #  #@popular_products = Product.popular(100)
  #  #else
  #  #  search_term = @search['name']
  #  #  @product_count = Product.where("name like '%#{search_term}%' ").size
  #  #  @products = Product.where("name like '%#{search_term}%' ").order("updated_at desc").page(params[:page]).per(100)
  #  #end
  #  redirect_to :controller => "products", :action => "index", :game_id => params[:id]
  #end
  #
  #def product_search
  #  redirect_to :controller => "products", :action => "index", :new_game => true
  #end

  def system_category_add
    @game = Game.find_by_id(params[:id])

    if current_user && (@game.owner == current_user || current_user.admin?)
      system_category = SystemCategory.find(params[:system_category_id])
      system_category.products.each do |product|
        @game.add_product(product)
        if @game.characters.any?
          @game.characters.each do |character|
            character.add_product(product)
          end
        end
      end
      @comments = @game.comments.order('created_at ASC').limit(200)
      redirect_to @game
    else
      flash[:error] = 'You may not edit games you do not own.'
      redirect_to user_path(current_user)
    end
  end

  def product_add
    @game = Game.find_by_id(params[:id])

    if current_user && (@game.owner == current_user || current_user.admin?)
      product = Product.find(params[:product_id])
      @game.add_product(product)
      if @game.characters.any?
        @game.characters.each do |character|
          character.add_product(product)
        end
      end
      @comments = @game.comments.order('created_at ASC').limit(200)
      redirect_to @game
    else
      flash[:error] = 'You may not edit games you do not own.'
      redirect_to user_path(current_user)
    end
  end

  def product_remove
    @game = Game.find_by_id(params[:id])

    if current_user && (@game.owner == current_user || current_user.admin?)
      @game = Game.find_by_id(params[:id])
      product = Product.find(params[:product_id])
      @game.products.delete(product)
      @comments = @game.comments.order('created_at ASC').limit(200)
      render 'games/products'
    else
      flash[:error] = 'You may not edit games you do not own.'
      redirect_to user_path(current_user)
    end
  end

  def product_remove_all
    @game = Game.find_by_id(params[:id])
    if current_user && (current_user == @game.owner || current_user.admin?)
      products = @game.products
      @game.products.destroy(products)
      flash[:notice] = "All products removed"
    else
      flash[:error] = "You may not remove products from a game you do not own."
    end

    redirect_to @game
  end

  def private_game
    @game = Game.find_by_id(params[:id])
  end

  def private_filter
    game = Game.find_by_id(params[:id])
    if game && !game.has_access(current_user)
      redirect_to private_game_url
    end
  end

  private
  def game_params
    params.require(:game).permit(:name,
                                 :status,
                                 :player_seats,
                                 :alternate_seats,
                                 :others_can_clone,
                                 :allow_spectators,
                                 :use_video,
                                 :is_private,
                                 :min_age,
                                 :max_age,
                                 :start_at,
                                 :old_start_at,
                                 :session_length,
                                 :number_of_sessions,
                                 :is_d20pro,
                                 :d20pro_ip,
                                 :d20pro_port,
                                 :d20pro_password,
                                 :description,
                                 :premise,
                                 :style_of_play,
                                 :room_id,
                                 :public_notepad,
                                 :owner_notepad,
                                 :id, :_destroy, :tag_list)
  end

end
