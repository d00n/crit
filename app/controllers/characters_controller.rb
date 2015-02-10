class CharactersController < BaseController
  include Viewable

  before_filter :valid_character_required, :except =>
    [ :index,
    :user_characters,
    :new,
    :create,
    :private_game_filter]

  before_filter :private_filter, :except => [:private_game_filter, :index, :new, :create]


  before_filter :login_required, :except => [:products, :index, :show, :sheet, :notepad, :update_views]

  cache_sweeper :taggable_sweeper, :only => [:activate, :update, :destroy]
  protect_from_forgery :only => [:create, :update, :destroy]
  #auto_complete_for :character, :genre
  #auto_complete_for :character, :property


  uses_tiny_mce do
    {:only => [:new, :create, :update, :edit, :edit_notepad, :show],
      :options => configatron.default_mce_options}
  end


  # GET /user/characters
  def user_characters
    cond, @search = Character.paginated_users_conditions_with_search(params)
    cond.append ['user_id = ?', :user_id]

    @owner = User.find(:user_id)

    @characters = Character.recent.(:conditions => cond.to_sql, :include => [:tags], :page => {:current => params[:page], :size => 10} )

    respond_to do |format|
      format.html
      format.xml  { render :xml => @characters }
    end
  end

  # GET /characters
  # GET /characters.xml
  def index
    characters, @search = Character.search_conditions(params)

    @characters_found = characters.count

    @characters = characters.recent.page(params[:page]).per(20)

    @popular_tags = popular_tags(30).to_a
    @tags = Character.tag_counts :limit => 10

    @featured_characters = Array.new

    if Character.exists?(26)
      @featured_characters << Character.find(26)
    end

    if Character.exists?(25)
      @featured_characters << Character.find(25)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @characters }
    end
  end

  # GET /characters/1
  # GET /characters/1.xml
  def show
    begin
      @character = Character.find(params[:id])
    rescue
      flash[:error] = 'Characcter not found.'
      redirect_to characters_url
      return
    end
    
    @comments = @character.comments.order('created_at ASC').limit(200)

    @posts = @character.posts.recent.limit(5)


    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @character }
    end
  end

  def sheet
    begin
      @character = Character.find(params[:id])
    rescue
      flash[:error] = 'Characcter not found.'
      redirect_to characters_url
      return
    end

    @character = Character.find(params[:id])

    respond_to do |format|
      format.html # sheet.html.erb
      format.xml  { render :xml => @character }
    end
  end

  def print
    begin
      @character = Character.find(params[:id])
    rescue
      flash[:error] = 'Characcter not found.'
      redirect_to characters_url
      return
    end

    @character = Character.find(params[:id])
    @comments = @character.comments.find(:all, :limit => 10, :order => 'created_at DESC')
    @posts = @character.posts.recent

    respond_to do |format|
      format.html { render :layout => 'print'}
    end
  end

  def game_table_sheet
    begin
      @character = Character.find(params[:id])
    rescue
      flash[:error] = 'Characcter not found.'
      redirect_to characters_url
      return
    end

    render :layout => 'none'
  end

  def notepad
    begin
      @character = Character.find(params[:id])
    rescue
      flash[:error] = 'Characcter not found.'
      redirect_to characters_url
      return
    end

    @character = Character.find(params[:id])

    respond_to do |format|
      format.html # notepad.html.erb
      format.xml  { render :xml => @character }
    end
  end

  def update_views
    if logged_in?
      @character= Character.find(params[:id])
      updated = update_view_count(@character)
      render :text => updated ? 'updated' : 'duplicate'
      return
    end

    # not really a dup, but this isn't displayed anyway
    render :text => 'duplicate'
  end


  # GET /characters/new
  # GET /characters/new.xml
  def new
    @auto_register_game_id = params[:auto_register_game_id]

    @character = current_user.characters.new
    6.times { @character.c_attributes.build }
    3.times { @character.c_skills.build }
    3.times { @character.c_special_attributes.build }
    3.times { @character.c_qualities.build }
    3.times { @character.c_special_abilities.build }
    3.times { @character.c_powers.build }
    3.times { @character.c_maxwounds.build }
    3.times { @character.c_healings.build }
    3.times { @character.c_armors.build }
    3.times { @character.c_wound_levels.build }
    3.times { @character.c_weapons.build }
    3.times { @character.c_possessions.build }

    @character.c_distinguishing_features.build
    @character.c_mannerisms.build
    @character.c_virtues.build
    @character.c_flaws.build
    @character.c_educations.build
    @character.c_trainings.build
    @character.c_interests.build
    @character.c_hobbies.build
    @character.c_goals.build

    2.times { @character.c_combats.build }
    # @character.c_combats[0].name = 'Initiative'
    # @character.c_combats[1].name = 'Common Attack'
    # @character.c_combats[2].name = 'Common Attack'
    # @character.c_combats[3].name = 'Common Defense'
    # @character.c_combats[4].name = 'Common Defense'
    # @character.c_combats[5].name = 'Common Maneuver'
    # @character.c_combats[6].name = 'Common Maneuver'
    # @character.c_combats[7].name = 'Common Maneuver'
    # @character.c_combats[8].name = 'Misc Bonuses'
    # @character.c_combats[9].name = 'Misc Penalties'

    2.times { @character.c_damages.build }
    # @character.c_damages[0].name = 'Max Damage'
    # @character.c_damages[1].name = 'Wound Level'
    # @character.c_damages[2].name = 'Wound Level'
    # @character.c_damages[3].name = 'Wound Level'
    # @character.c_damages[4].name = 'Wound Level'
    # @character.c_damages[5].name = 'Wound Level'
    # @character.c_damages[6].name = 'Wound Level'
    # @character.c_damages[7].name = 'Healing Abilities'
    # @character.c_damages[8].name = 'Physical Conditions'
    # @character.c_damages[9].name = 'Mental Conditions'

    2.times { @character.c_movements.build }
    # @character.c_movements[0].name = 'Max Speed'
    # @character.c_movements[1].name = 'Cautious Speed'
    # @character.c_movements[2].name = 'Penalties'
    # @character.c_movements[3].name = 'Misc'

    2.times { @character.c_physical_abilities.build }
    # @character.c_physical_abilities[0].name = 'Lift'
    # @character.c_physical_abilities[1].name = 'Carry'
    # @character.c_physical_abilities[2].name = 'Push/Drag'
    # @character.c_physical_abilities[3].name = 'Jump'
    # @character.c_physical_abilities[4].name = 'Climb'
    # @character.c_physical_abilities[5].name = 'Swim'
    # @character.c_physical_abilities[6].name = 'Fly'
    # @character.c_physical_abilities[7].name = 'Other'

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @character }
    end
  end

  # GET /characters/1/edit
  def edit
    @character = current_user.characters.find(params[:id], :include => [:c_carried_items, :c_special_items, :c_languages, :c_wealths, :c_physical_abilities, :c_senses, :c_previous_professions, :c_previous_classes, :c_armors, :c_attributes, :c_healings, :c_maxwounds, :c_movements, :c_possessions, :c_powers, :c_combats, :c_damages, :c_qualities, :c_racial_abilities, :c_skills, :c_skill_specializations, :c_special_abilities, :c_special_attributes, :c_defenses, :c_weapons, :c_wound_levels, :c_distinguishing_features, :c_mannerisms, :c_virtues, :c_flaws, :c_educations, :c_trainings, :c_interests, :c_hobbies, :c_goals])
  end

  # GET /characters/1/edit_clone
  def edit_clone
    original = Character.find(params[:id])

    if original.others_can_clone || current_user == original.owner
      @character = original.get_clone(current_user)
      redirect_to edit_character_path(@character)
      return
    end

    flash[:notice] = 'You may not clone a character you do not own.'
    redirect_to(@character)
  end

  # POST /characters
  # POST /characters.xml
  def create
    @character = current_user.characters.new(params[:character])

    # This has issues with case, resulting in dupes of the same tag
    #@character.tag_list = params[:character][:property] + ", " + params[:tag_list]
    @character.tag_list = params[:tag_list]

    respond_to do |format|
      if @character.save

        if params[:auto_register_game_id]
          @game = Game.find_by_id(params[:auto_register_game_id])
          playerRegistration = PlayerRegistration.find_by_game_id_and_user_id(params[:auto_register_game_id], current_user.id)

          if @game && playerRegistration
            characterRegistration = CharacterRegistration.new
            @game.character_registrations << characterRegistration
            @character.character_registrations << characterRegistration
            characterRegistration.status = playerRegistration.status
            playerRegistration.character_registrations << characterRegistration

            @character.associate_products_from_game(@game)

            if characterRegistration.status == 'active'
              UserNotifier.game_register_character_notice(@game, characterRegistration).deliver
            end

            redirect_to registration_desk_path(@game)
            return
          else
            flash[:error] = 'You can not create characters for a game you are not registered in.'
            redirect_to(@character)
            return
          end

        end

        flash[:notice] = 'Character was successfully created.'
        format.html { redirect_to(@character) }
        format.xml  { render :xml => @character, :status => :created, :location => @character }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @character.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /characters/1
  # PUT /characters/1.xml
  def update
    @character = current_user.characters.find(params[:id])

    # This has issues with case, resulting in dupes of the same tag
    #@character.tag_list = params[:character][:property] + ", " + params[:tag_list]
    @character.tag_list = params[:tag_list]

    respond_to do |format|
      if @character.update_attributes(params[:character])

        flash[:notice] = 'Character was successfully updated.'
        format.html { redirect_to(@character) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @character.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /characters/1
  # DELETE /characters/1.xml
  def destroy
    @character = current_user.characters.find(params[:id])
    @character.destroy

    respond_to do |format|
      format.html { redirect_to(characters_url) }
      format.xml  { head :ok }
    end
  end

  def edit_notepad
    @character = current_user.characters.find(params[:id])
  end

  def update_notepad
    @character = current_user.characters.find(params[:id])

    attributes = character_params.permit!

    respond_to do |format|
      if @character.update_attributes(attributes)
        flash[:notice] = 'Character notepads were successfully updated.'
        format.html { redirect_to(@character) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit_notepad" }
        format.xml  { render :xml => @character.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update_views
    if logged_in?
      @character = Character.find(params[:id])
      updated = update_view_count(@character)
      render :text => updated ? 'updated' : 'duplicate'
      return
    end

    # not really a dup, but this isn't displayed anyway
    render :text => 'duplicate'
  end

  def change_profile_photo
    @character = current_user.characters.find(params[:id])

    # TODO make this a before_filter
    if current_user != @character.owner
      flash[:error] = "You can not edit this character."
      redirect_to seo_character_path(@character)
      return
    end

    @photo  = Photo.find(params[:photo_id])
    @character.avatar = @photo

    if @character.save!
      flash[:notice] = 'Character was successfully updated.'

      @photo.is_private = @character.is_private
      @photo.save!
      
      redirect_to seo_character_path(@character)
    else
      format.html { render :action => "edit" }
    end
  rescue ActiveRecord::RecordInvalid
    render :action => 'edit'
  end

  def pick_profile_photo
    @character = current_user.characters.find(params[:id])

    # TODO make this a before_filter
    if current_user != @character.owner
      flash[:error] = "You can not edit this character."
      redirect_to seo_character_path(@character)
      return
    end

    @user = @character.owner
    @photos = @user.photos.recent.page(params[:page]).per(100)


    respond_to do |format|
      format.html # index.rhtml
    end
  end


  def new_avatar_photo
     @character = current_user.characters.find(params[:id])

   if current_user == @character.owner
      @photo = Photo.new
    else
      flash[:notice] = "You are not allowed to modify a character you do not own."
      redirect_to seo_character_path(@character)
    end
  end


  def private_filter
    character = Character.find(params[:id])

    if current_user
      if !character.has_access(current_user)
        flash[:notice] = "That character is private."
        redirect_to characters_url
        return
      end
    else
      if character.is_private
        flash[:notice] = "That character is private."
        redirect_to characters_url
        return
      end
    end

  end

  def products
    @character = Character.find(params[:id])
    @comments = @character.comments.order('created_at ASC').limit(200)
  end

  def product_search
    redirect_to :controller => "products", :action => "index", :character_id => params[:id]
  end

  def product_add
    @character = Character.find(params[:id])

    if current_user && ( @character.owner == current_user || current_user.admin? )
      product = Product.find(params[:product_id])
      @character.add_product(product)
      @comments = @character.comments.order('created_at ASC').limit(200)
      render 'characters/products'
    else
      flash[:error] = 'You may not edit characters you do not own.'
      redirect_to user_path(current_user)
    end
  end

  def product_remove
    @character = Character.find(params[:id])

    if current_user && ( @character.owner == current_user || current_user.admin? )
      product = Product.find(params[:product_id])
      @character.products.destroy(product)
      @comments = @character.comments.order('created_at ASC').limit(200)
      render 'characters/products'
    else
      flash[:error] = 'You may not edit characters you do not own.'
      redirect_to user_path(current_user)
    end
  end

  protected
  def character_params
    params[:character].permit(:owner_notepad, :public_notepad)
  end

end
