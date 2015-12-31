class Game < ActiveRecord::Base
  require 'builder'
  belongs_to :user
  belongs_to :game_system
  
  has_many :pregenerated_character_offers, :dependent => :destroy  
  has_many :pregenerated_character_requests, :dependent => :destroy  
  
  has_many :character_registrations, :dependent => :destroy
  has_many :characters, :through => :character_registrations
  
  has_many :player_registrations, :dependent => :destroy
  has_many :players, :through => :player_registrations
  
  has_many :slot_game_registrations, :dependent => :destroy
  has_many :slots, :through => :slot_game_registrations  
  
  has_many :posts, -> {order "published_at desc"}
  
  has_many :unlocked_achievements, :dependent => :destroy

  has_many :game_products, :dependent => :destroy
  has_many :products, :through => :game_products

  acts_as_commentable
  acts_as_taggable  
  scope :recent, -> {order 'games.updated_at DESC'}
  acts_as_activity :user
  
  validates_presence_of :name , :start_at 
  validates_numericality_of :player_seats, :alternate_seats, :min_age, :max_age, :greater_than_or_equal_to => 0

  belongs_to  :avatar, :class_name => "Photo", :foreign_key => "avatar_id"

  has_event_calendar

  #  friendly_id :name, :use => [:slugged, :finders]

  def to_param
    id.to_s << "-" << (name ? name.parameterize : '' )
  end

  def owner
    self.user
  end

  def avatar_photo_url(size = nil)
    if avatar
      avatar.photo.url(size)

    elsif products.any?
      if !products.first.dtrpg_product_image.blank?
        products.first.dtrpg_product_image
      elsif !products.first.amazon_image_url.blank?
        products.first.amazon_image_url
      end

    else
      case size
        when :thumb
          configatron.photo.missing_thumb.to_s
        else
          configatron.photo.missing_medium.to_s
      end
    end
  end
  
  # Search, pagination code - START  
  def self.search_conditions_with_metros_and_states(params, gameSystem_id)
    search = prepare_params_for_search(params)
    metro_areas, states = find_country_and_state_from_search_params(search)
    games = build_conditions_for_search(search, gameSystem_id)
    return games, search, metro_areas, states
  end   
 
  def self.prepare_params_for_search(params)
    search = {}.merge(params)
    search['metro_area_id'] = params[:metro_area_id] || nil
    search['state_id'] = params[:state_id] || nil
    search['country_id'] = params[:country_id] || nil
    search['skill_id'] = params[:skill_id] || nil    
    search
  end
    
  def self.find_country_and_state_from_search_params(search)
    country     = Country.find(search['country_id']) if !search['country_id'].blank?
    state       = State.find(search['state_id']) if !search['state_id'].blank?
    metro_area  = MetroArea.find(search['metro_area_id']) if !search['metro_area_id'].blank?

    if metro_area && metro_area.country
      country ||= metro_area.country 
      state   ||= metro_area.state
      search['country_id'] = metro_area.country.id if metro_area.country
      search['state_id'] = metro_area.state.id if metro_area.state      
    end
    
    states  = country ? country.states.sort_by{|s| s.name} : []
    if states.any?
      metro_areas = state ? state.metro_areas.all(:order => "name") : []
    else
      metro_areas = country ? country.metro_areas : []
    end    
    
    return [metro_areas, states]
  end
  
    
  def self.build_conditions_for_search(search, gameSystem_id)
    games = Game.recent

    games = games.where(:is_private => false)

    if search['country_id'] && !(search['metro_area_id'] || search['state_id'])
      games = games.where(game[:country_id].eq(search['country_id']))
    end
    if search['state_id'] && !search['metro_area_id']
      games = games.where(game[:state_id].eq(search['state_id']))
    end
    if search['metro_area_id']
      games = games.where(game[:metro_area_id].eq(search['metro_area_id']))
    end
    if !search['name'].blank?
      games = games.where("name like ?", "%#{search['name'].strip}%")
    end   
    if !search['genre'].blank?
      games = games.where( :genre => search['genre'] )
    end    
    if search['status']    
      games = games.where( :status => 'open' )
    end      
    if search['is_d20pro']
      games = games.where( :is_d20pro => true )
    end
    if !search['description'].blank?
      games = games.where( :description => search['description'] )
    end        
    if gameSystem_id != 0
      games = games.where(:game_system_id => gameSystem_id)
    end        
    
    games
  end 
  # Search, pagination code - END  
  
     
  def active_characters()
    active_characters = []
     
    self.character_registrations.where("status = 'active'").each do |character_registration|
      active_characters << Character.find(character_registration.character_id)
    end
    
    return active_characters
  end
  
     
  def active_players()
    active_players = []
     
    self.player_registrations.where("status = 'active'").each do |player_registration|
      active_players << User.find(player_registration.user_id)
    end
    
    return active_players
  end  
  
  def alternate_players()
    alternate_players = []
     
    self.player_registrations.where("status = 'alternate'").order('created_at').each do |player_registration|
      alternate_players << User.find(player_registration.user_id)
    end
    
    return alternate_players
  end   
  
  def alternate_position(user)
    pos = 0;
    self.player_registrations.where("status = 'alternate'").order('created_at').each do |player_registration|
      pos = pos + 1;
      if player_registration.user == user
        return pos;
      end
    end
  end      
  
  def pending_characters()
    pending_characters = []
     
    self.character_registrations.where("status = 'pending'").each do |character_registration|
      pending_characters << Character.where(id: character_registration.character_id).first
    end
    
    return pending_characters
  end  
  
  def pending_players()
    pending_players = []
     
    self.player_registrations.where("status = 'pending'").each do |player_registration|
      pending_players << User.where(id: player_registration.user_id).first
    end
    
    return pending_players
  end  
  
  def has_active_character(current_user)   
    self.character_registrations.each do |character_registration|
      character = Character.where(id: character_registration.character_id).first
      if character_registration.status == 'active' && character.owner == current_user
        return true;
      end
    end
    
    return false
  end    
  
  def active_characters_for_player(user)  
    active_characters = []
    self.character_registrations.each do |character_registration|
      character = Character.where(id: character_registration.character_id).first
      if character_registration.status == 'active' && character.owner == user
        active_characters << character
      end
    end
    
    return active_characters
  end    
  
  def pending_characters_for_player(user)  
    active_characters = []
    self.character_registrations.each do |character_registration|
      character = Character.where(id: character_registration.character_id).first
      if character_registration.status == 'pending' && character.owner == user
        active_characters << character
      end
    end
    
    return active_characters
  end    

  def active_players_pm_blast_list(sender)
    to_list = ''
    
    self.active_players.each do |active_player|
      if self.owner != active_player && sender != active_player
        if !to_list.empty?
          to_list << ', '
        end
        to_list << active_player.login_slug
      end
    end
    
    return to_list
  end

  def alternate_players_pm_blast_list(sender)
    to_list = ''

    self.alternate_players.each do |alternate_players|
      if self.owner != alternate_players && sender != alternate_players
        if !to_list.empty?
          to_list << ', '
        end
        to_list << alternate_players.login_slug
      end
    end

    return to_list
  end
  
  # When this is called from _profile_game_info_sidebar.html.haml, it works
  # but the to_list somehow gets used later for user_path(@game.owner)
  # big ole WTF
  def players_and_owner_pm_blast_list(sender)
    to_list = ''
    
    if sender != self.owner
      to_list = self.owner.login_slug
    end
      
    self.active_players.each do |active_player|
      if self.owner != active_player && sender != active_player
        if !to_list.empty?
          to_list << ', '
        end
        to_list << active_player.login_slug
      end
    end
    
    return to_list
  end  
  
  def system_name
    game_system.name if game_system
  end
  
  def system_name=(name)
    self.game_system = GameSystem.find_or_create_by_name(name) unless name.blank?
  end

  def get_clone(new_owner)
    @game= Game.new
    @game.user_id = new_owner.id

    @game.name = self.name
    @game.created_at = Time.now
    @game.updated_at = Time.now
    @game.status = self.status
    @game.description = self.description
    @game.genre = self.genre
    @game.system_deprecated = self.system_deprecated
    @game.premise = self.premise
    @game.style_of_play = self.style_of_play
    @game.player_seats = self.player_seats
    @game.next_game_time = self.next_game_time
    @game.view_count = self.view_count
    @game.avatar_id = self.avatar_id
    @game.session_length = self.session_length
    @game.min_age = self.min_age
    @game.max_age = self.max_age
    @game.owner_notepad = self.owner_notepad
    @game.group_notepad = self.group_notepad
    @game.public_notepad = self.public_notepad
    @game.number_of_sessions = self.number_of_sessions
    @game.allow_spectators = self.allow_spectators
    @game.d20pro_port = self.d20pro_port
    @game.is_d20pro = self.is_d20pro
    @game.d20pro_ip = self.d20pro_ip
    @game.d20pro_password = self.d20pro_password
    @game.d20pro_ready_to_play = self.d20pro_ready_to_play
    @game.game_system_id = self.game_system_id
    @game.start_at = self.start_at
    @game.end_at = self.end_at
    @game.auto_approve_player_registrations = self.auto_approve_player_registrations
    @game.alternate_seats = self.alternate_seats
    @game.others_can_clone = self.others_can_clone
    @game.tag_list = self.tag_list
    @game.save

    self.products.each do |product|
      @game.products << product
    end

    self.pregenerated_character_offers.each do |pregen|
      character = pregen.character
      pregeneratedCharacterOffer = PregeneratedCharacterOffer.new
      @game.pregenerated_character_offers << pregeneratedCharacterOffer
      character.pregenerated_character_offers << pregeneratedCharacterOffer
      pregeneratedCharacterOffer.save
    end

    @game.save
    return @game

  end

  def image_tag_title
    self.name + ", " + self.start_at.strftime('%a, %b %d, %I:%M%p %Z')
  end

  def is_owner?(user)
    return (self.owner == user)
  end
  
  def updateWithSlotInfo(slot)
    self.status = 'closed'
    self.auto_approve_player_registrations = true
    self.alternate_seats = EVENT_ALTERNATE_SEATS
    self.start_at = slot.start_time
    self.end_at = slot.start_time + 1
    self.session_length = ((slot.end_time - slot.start_time) / 1.hour).to_i.to_s + ' hours'
  end


  def set_opentok_session(remote_addr)
    begin
      opentok = OpenTok::OpenTokSDK.new OPENTOK_API_KEY, OPENTOK_API_SECRET
      session_properties = {OpenTok::SessionPropertyConstants::P2P_PREFERENCE => "disabled"}
      opentok_session_id = opentok.create_session(remote_addr, session_properties)
      self.opentok_session_id = opentok_session_id.to_s
      self.save!
    #rescue OpenTokException
    rescue Exception
      logger.error("Games.set_opentok_session()")
      UserNotifier.game_play_kerfuffle(self, "Games.set_opentok_session() error").deliver
      #flash[:error] = "Game table did not load correctly. Please try again."
      redirect_to :action => "show", :id => params[:id]
    end
  end

  def open_player_seats
    return self.player_seats - self.active_players.size
  end

  def open_alternate_seats
    return self.alternate_seats - self.alternate_players.size
  end

  def is_registered(user)
    if (user && (
          (self.pending_players.include?user) ||
          (self.active_players.include?user) ||
          (self.alternate_players.include?user) ) )
      return true
    end
    return false
  end

  def has_access(user)
    if !self.is_private
      return true
    end

    if user.nil?
      return false
    end

    if (user == self.owner) || (self.active_players.include?user) || user.admin?
      return true
    end

    return false
  end

  def open_player_seats
    return self.player_seats - self.player_registrations.count
  end

  def open_alternate_seats
    return self.alternate_seats - self.alternate_players.size
  end

  def pending_achievements
    return self.unlocked_achievements.where(:accepted => false)
  end

  def accepted_achievements
    return self.unlocked_achievements.where(:accepted => true)
  end

  def add_product(product)
    if !self.products.include?product
      self.products << product
    end
  end

  protected
  #def validate
  #  errors.add("start_time", " must be before end time") unless start_at && end_at && (start_at < end_at)
  #end

end
