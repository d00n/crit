class UsersController < BaseController
  require_from_ce('controllers/users_controller')

  before_filter :admin_required, :only => [:assume, :destroy, :featured, :toggle_featured, :toggle_moderator,
                                           :newsletter_user_list,
                                           :newsletter_admin_list,
                                           :newsletter_power_user_list ]

  uses_tiny_mce do
    {:only => [:show, :edit, :update], :options => configatron.default_mce_options}
  end

  def activate
    if params[:id].blank?
      flash[:error] = 'Missing activation code'
      redirect_to signup_path
      return
    end

    @user = User.find_by_activation_code(params[:id])
    if @user and @user.activate
      self.current_user = @user
      @user.track_activity(:joined_the_site)
      #flash[:notice] = :thanks_for_activating_your_account.l
      #redirect_to welcome_photo_user_path(@user) and return
      redirect_to premium_membership_path
      return
    end

    flash[:error] = :account_activation_error.l_with_args(:email => configatron.support_email)
    redirect_to signup_path
  end


  #def update
  #  @metro_areas, @states = setup_locations_for(@user)
  #
  #  if !params[:user].blank? && !params[:user][:free_stuff_url].blank?
  #    if (params[:user][:free_stuff_url][0..6].casecmp 'http://') != 0
  #      @user.free_stuff_url = 'http://' + params[:user][:free_stuff_url]
  #    end
  #  end
  #
  #  unless params[:metro_area_id].blank?
  #    @user.metro_area  = MetroArea.find(params[:metro_area_id])
  #    @user.state       = (@user.metro_area && @user.metro_area.state) ? @user.metro_area.state : nil
  #    @user.country     = @user.metro_area.country if (@user.metro_area && @user.metro_area.country)
  #  else
  #    @user.metro_area = @user.state = @user.country = nil
  #  end
  #
  #  @user.tag_list = params[:tag_list] || ''
  #
  #  params[:user][:avatar_attributes].merge!(:user_id => @user.id) if params[:user] && params[:user][:avatar_attributes]
  #
  #  if @user.update_attributes(params[:user])
  #    @user.track_activity(:updated_profile)
  #
  #    flash[:notice] = :your_changes_were_saved.l
  #
  #    #if params[:welcome] == "invite"
  #    #  redirect_to user_path(@user)
  #    #  return
  #    #end
  #
  #    unless params[:welcome]
  #      redirect_to user_path(@user)
  #    else
  #      redirect_to :action => "welcome_#{params[:welcome]}", :id => @user
  #    end
  #  else
  #    render :action => 'edit'
  #  end
  #end


  #def destroy
  #  if current_user && (current_user.admin? || current_user.user_admin?)
  #     # destroying the user does delete their posts, but does not trigger the post cache sweeper
  #    @user.posts.each do |post|
  #      post.destroy
  #    end
  #    @user.destroy
  #    flash[:notice] = :the_user_was_deleted.l
  #  else
  #    UserNotifier.access_violation_notice(current_user, 'destroy', request).deliver
  #    flash[:error] = :you_cant_delete_that_user.l
  #  end
  #  respond_to do |format|
  #    format.html { redirect_to users_url }
  #  end
  #end


#  def upload_profile_photo
#    photo       = Photo.new(params[:photo])
#    return unless request.put?
#
#    debugger
#    photo.save
#
#    @user.avatar = photo
#    if @user.save!
#      redirect_to crop_profile_photo_user_path(@user)
#    end
#  end

  def grant_epic
    if current_user && current_user.admin?
      @user= User.find(params[:id])

      @user.membership_level = 1

      if @user.save!
        UserNotifier.user_premium_granted_notice(@user, 'Epic').deliver
        flash[:notice] = :your_changes_were_saved.l
        redirect_to user_path(@user)
        return
      end

    else
      UserNotifier.access_violation_notice(current_user, 'grant_epic', request).deliver
      flash[:error] = 'Denied. This will go in your permanent record.'
      redirect_to user_path(@user)
    end
  end

  def grant_legendary
    if current_user && current_user.admin?
      @user= User.find(params[:id])

      @user.membership_level = 2

      if @user.save!
        UserNotifier.user_premium_granted_notice(@user, 'Legendary').deliver
        flash[:notice] = :your_changes_were_saved.l
        redirect_to user_path(@user)
        return
      end

    else
      UserNotifier.access_violation_notice(current_user, 'grant_legendary', request).deliver
      flash[:error] = 'Denied. This will go in your permanent record.'
      redirect_to user_path(@user)
    end
  end

  def grant_exalted
    if current_user && current_user.admin?
      @user= User.find(params[:id])

      @user.membership_level = 3

      if @user.save!
        UserNotifier.user_premium_granted_notice(@user, 'Exalted').deliver

        message = "#{@user.first_name} has unlocked Exalted status on Infrno, the best place online to play RPGs. Come play with us!"
        picture = APP_URL + User.find(5).avatar_photo_url(:thumb)
        link = home_url
        name = home_url
        description = "Infrno is a place to play any tabletop, pen-and-paper RPG on a virtual game table. Can't get your old gaming crew together IRL? Looking for new people to play with? Infrno has video chat, a die roller, and a shared whiteboard, all for FREE!"
        fb_wall_post(@user, message, picture, link, name, description)

        flash[:notice] = :your_changes_were_saved.l
        redirect_to user_path(@user)
        return
      end

    else
      UserNotifier.access_violation_notice(current_user, 'grant_exalted', request).deliver
      flash[:error] = 'Denied. This will go in your permanent record.'
      redirect_to user_path(@user)
    end
  end

  def grant_mythic
    if current_user && current_user.admin?
      @user= User.find(params[:id])

      @user.membership_level = 4

      if @user.save!
        UserNotifier.user_premium_granted_notice(@user, 'Mythic').deliver
        flash[:notice] = :your_changes_were_saved.l
        redirect_to user_path(@user)
        return
      end

    else
      UserNotifier.access_violation_notice(current_user, 'grant_mythic', request).deliver
      flash[:error] = 'Denied. This will go in your permanent record.'
      redirect_to user_path(@user)
    end
  end

  def revoke_premium
    if current_user && current_user.admin?
      @user= User.find(params[:id])

      @user.membership_level = 0

      if @user.save!
        flash[:notice] = :your_changes_were_saved.l
        UserNotifier.user_premium_revoked_notice(@user).deliver
        redirect_to user_path(@user)
        return
      end

    else
      UserNotifier.access_violation_notice(current_user, 'revoke_premium', request).deliver
      flash[:error] = 'Denied. This will go in your permanent record.'
      redirect_to user_path(@user)
    end
  end


  def grant_network_god_mode_access
    if current_user && current_user.admin?
      @user= User.find(params[:id])

      @user.enable_network_god_mode = true;

      if @user.save!
        flash[:notice] = :your_changes_were_saved.l
        redirect_to user_path(@user)
        return
      end

    else
      UserNotifier.access_violation_notice(current_user, 'grant_network_god_mode_access', request).deliver
      flash[:error] = 'Denied. This will go in your permanent record.'
      redirect_to user_path(@user)
    end
  end


  def revoke_network_god_mode_access
    if current_user && current_user.admin?
      @user= User.find(params[:id])

      @user.enable_network_god_mode = false;

      if @user.save!
        flash[:notice] = :your_changes_were_saved.l
        redirect_to user_path(@user)
        return
      end

    else
      UserNotifier.access_violation_notice(current_user, 'revoke_network_god_mode_access', request).deliver
      flash[:error] = 'Denied. This will go in your permanent record.'
      redirect_to user_path(@user)
    end
  end

  def grant_event_admin
    if current_user && current_user.admin?
      @user= User.find(params[:id])

      @user.event_admin = true;

      if @user.save!
        flash[:notice] = :your_changes_were_saved.l
        redirect_to user_path(@user)
        return
      end

    else
      UserNotifier.access_violation_notice(current_user, 'grant_event_admin', request).deliver
      flash[:error] = 'Denied. This will go in your permanent record.'
      redirect_to user_path(@user)
    end
  end


  def revoke_event_admin
    if current_user && current_user.admin?
      @user= User.find(params[:id])

      @user.event_admin = false;

      if @user.save!
        flash[:notice] = :your_changes_were_saved.l
        redirect_to user_path(@user)
        return
      end

    else
      UserNotifier.access_violation_notice(current_user, 'revoke_event_admin', request).deliver
      flash[:error] = 'Denied. This will go in your permanent record.'
      redirect_to user_path(@user)
    end
  end

  def grant_chat_admin
    if current_user && current_user.admin?
      @user= User.find(params[:id])

      @user.chat_admin = true;

      if @user.save!
        flash[:notice] = :your_changes_were_saved.l

        UserNotifier.chat_admin_granted_notice(@user).deliver

        redirect_to user_path(@user)
        return
      end

    else
      UserNotifier.access_violation_notice(current_user, 'grant_chat_admin', request).deliver
      flash[:error] = 'Denied. This will go in your permanent record.'
      redirect_to user_path(@user)
    end
  end


  def revoke_chat_admin
    if current_user && current_user.admin?
      @user= User.find(params[:id])

      @user.chat_admin = false;

      if @user.save!
        flash[:notice] = :your_changes_were_saved.l

        UserNotifier.chat_admin_revoked_notice(@user).deliver

        redirect_to user_path(@user)
        return
      end

    else
      UserNotifier.access_violation_notice(current_user, 'revoke_chat_admin', request).deliver
      flash[:error] = 'Denied. This will go in your permanent record.'
      redirect_to user_path(@user)
    end
  end

  def grant_user_admin
    if current_user && current_user.admin?
      @user= User.find(params[:id])

      @user.user_admin = true;

      if @user.save!
        flash[:notice] = :your_changes_were_saved.l

        UserNotifier.user_admin_granted_notice(@user).deliver

        redirect_to user_path(@user)
        return
      end

    else
      UserNotifier.access_violation_notice(current_user, 'grant_user_admin', request).deliver
      flash[:error] = 'Denied. This will go in your permanent record.'
      redirect_to user_path(@user)
    end
  end


  def revoke_user_admin
    if current_user && current_user.admin?
      @user= User.find(params[:id])

      @user.user_admin = false;

      if @user.save!
        flash[:notice] = :your_changes_were_saved.l

        UserNotifier.user_admin_revoked_notice(@user).deliver

        redirect_to user_path(@user)
        return
      end

    else
      UserNotifier.access_violation_notice(current_user, 'revoke_user_admin', request).deliver
      flash[:error] = 'Denied. This will go in your permanent record.'
      redirect_to user_path(@user)
    end
  end

  def ban_user
    if current_user && current_user.admin?
      @user= User.find(params[:id])

      @user.is_banned = true;
      @user.persistence_token = 1;

      if @user.save!
        flash[:notice] = :your_changes_were_saved.l

        #UserNotifier.user_admin_granted_notice(@user).deliver

        redirect_to user_path(@user)
        return
      end

    else
      UserNotifier.access_violation_notice(current_user, 'ban_user', request).deliver
      flash[:error] = 'Denied. This will go in your permanent record.'
      redirect_to user_path(@user)
    end
  end


  def unban_user
    if current_user && current_user.admin?
      @user= User.find(params[:id])

      @user.is_banned = false;

      if @user.save!
        flash[:notice] = :your_changes_were_saved.l

        #UserNotifier.user_admin_revoked_notice(@user).deliver

        redirect_to user_path(@user)
        return
      end

    else
      UserNotifier.access_violation_notice(current_user, 'unban_user', request).deliver
      flash[:error] = 'Denied. This will go in your permanent record.'
      redirect_to user_path(@user)
    end
  end


  def grant_achievement_admin
    if current_user && current_user.admin?
      @user= User.find(params[:id])

      @user.achievement_admin = true;

      if @user.save!
        flash[:notice] = :your_changes_were_saved.l

        UserNotifier.achievement_admin_granted_notice(@user).deliver

        redirect_to user_path(@user)
        return
      end

    else
      UserNotifier.access_violation_notice(current_user, 'grant_achievement_admin', request).deliver
      flash[:error] = 'Denied. This will go in your permanent record.'
      redirect_to user_path(@user)
    end
  end


  def revoke_achievement_admin
    if current_user && current_user.admin?
      @user= User.find(params[:id])

      @user.achievement_admin = false;

      if @user.save!
        flash[:notice] = :your_changes_were_saved.l

        UserNotifier.achievement_admin_revoked_notice(@user).deliver

        redirect_to user_path(@user)
        return
      end

    else
      UserNotifier.access_violation_notice(current_user, 'revoke_achievement_admin', request).deliver
      flash[:error] = 'Denied. This will go in your permanent record.'
      redirect_to user_path(@user)
    end
  end



  def index_publishers
    @users, @search, @metro_areas, @states = User.search_conditions_with_metros_and_states(params)

    @popular_tags = popular_tags(30).to_a
    @users_found = @users.publisher.includes(:tags).count
    @users = @users.publisher.includes(:tags).page(params[:page]).per(20)

    @tags = User.tag_counts :limit => 10

    setup_metro_areas_for_cloud
    render :template => 'publishers/index'
  end


  def index
    @users, @search, @metro_areas, @states = User.search_conditions_with_metros_and_states(params)

    @popular_tags = popular_tags(30).to_a

    @users_found = @users.not_publisher.recent.includes(:tags).count
    @users = @users.not_publisher.recent.includes(:tags).page(params[:page]).per(20)

    @tags = User.tag_counts :limit => 10

    setup_metro_areas_for_cloud
  end

  # GET /user/characters
  def characters
    @user = User.find(params[:id])
    @characters = @user.characters.recent.page(params[:page]).per(20)


    respond_to do |format|
      format.html
      format.xml  { render :xml => @characters }
    end
  end


  def games_playing
    @user = User.find(params[:id])
    @games = @user.games_registered_in

    respond_to do |format|
      format.html
      format.xml  { render :xml => @characters }
    end
  end

  # GET /user/games
  def games
    @user = User.find(params[:id])
    @games = @user.games.recent.page(params[:page]).per(20)

    respond_to do |format|
      format.html
      format.xml  { render :xml => @characters }
    end
  end

  def newsletter_user_list
    @users = User.where("activated_at is not null").where("notify_admin_blasts = true").where("publisher = false")

    respond_to do |format|
      format.json {
        json_newsletter_user_list = create_user_list(@users)
        render :json => json_newsletter_user_list
      }
      format.csv {
        render 'newsletter_user_list'
      }
    end
  end

  def newsletter_admin_list
    @users = User.where("role_id = 1")

    respond_to do |format|
      format.json {
        json_newsletter_user_list = create_user_list(@users)
        render :json => json_newsletter_user_list
      }
      format.csv {
        render 'newsletter_user_list'
      }
    end
  end

  def newsletter_power_user_list
    @users = User.where("activated_at is not null").where("notify_admin_blasts = true").where("power_user = true")

    respond_to do |format|
      format.json {
        json_newsletter_user_list = create_user_list(@users)
        render :json => json_newsletter_user_list
      }
      format.csv {
        render 'newsletter_user_list'
      }
    end
  end


  def newsletter_publisher_list
    @users = User.where("activated_at is not null").where("notify_admin_blasts = true").where("publisher = true")

    respond_to do |format|
      format.json {
        json_newsletter_user_list = create_user_list(@users)
        render :json => json_newsletter_user_list
      }
      format.csv {
        render 'newsletter_publisher_list'
      }
    end
  end


  def create_user_list(users)
    list_hash = {}
    json_list = ''
    i = 0
    users.each do |user|
      user_hash = {}
      subvals_hash = {}

      user_hash["email"] = user.email
      user_hash["name"] = user.first_name  + " " + user.last_name
      subvals_hash["login"] = user.login
      subvals_hash["publisher_name"] = user.publisher_name
      user_hash["subvals"] = subvals_hash

      this_user = ActiveSupport::JSON.encode(user_hash)

      if json_list.empty?
        json_list = "["
      elsif i < users.length
        json_list = json_list + ","
      end

      json_list = json_list + this_user
      i += 1
    end

    if !json_list.empty?
      json_list = json_list + "]"
    end

    json_list
  end



  def update_views
    if logged_in?
      @user= User.find(params[:id])
      updated = update_view_count(@user)
      render :text => updated ? 'updated' : 'duplicate'
      return
    end

    # not really a dup, but this isn't displayed anyway
    render :text => 'duplicate'
  end


  #def new
  #  @user         = User.new( {:birthday => Date.parse((Time.now - 25.years).to_s) }.merge(params[:user] || {}) )
  #  #@user         = User.new( {:birthday => Date.parse((Time.now - 25.years).to_s)) } )
  #  @inviter_id   = params[:id]
  #  @inviter_code = params[:code]
  #
  #  flash.clear
  #
  #  render :layout => 'single_column'
  #end

  def new_facebook
    redirect_to home_url
  end

  def new_publisher
    @user         = User.new( {:birthday => Date.parse((Time.now - 25.years).to_s) }.merge(params[:user] || {}) )
    @inviter_id   = params[:id]
    @inviter_code = params[:code]
    @user.publisher = true

    render :action => 'new_publisher'
  end

  def create
    @user       = User.new(user_params)
    @user.role  = Role[:member]

    if @user.email.end_with?('outlook.com')
      flash[:notice] = 'You must ask a moderator for help about reg code 42'
      render :layout => 'single_column', :action => 'new'
      return
    end

    if params[:tos_pp_agreement] != "1"
      flash[:notice] = 'You must agree to the Terms of Service and Privacy Policy'
      render :layout => 'single_column', :action => 'new'
      return
    end

    if (!configatron.require_captcha_on_signup || verify_recaptcha({ :model => @user, :private_key => configatron.recaptcha_priv_key}) ) && @user.save
      create_friendship_with_inviter(@user, params)
      create_friendship_with_kieara(@user)

      if BOOTH_VISIT_ACHIEVEMENT_ENABLED && request.remote_ip.starts_with?(BOOTH_VISIT_REMOTE_IP)
        achievement = Achievement.find(BOOTH_VISIT_ACHIEVEMENT_ID)
        @user.achievements << achievement
      end

      @user.save

      flash[:notice] = :email_signup_thanks.l_with_args(:email => @user.email)
      redirect_to signup_completed_user_path(@user)
    else
      if @user.publisher
         render :layout => 'single_column', :action => 'new_publisher'
      else
         render :layout => 'single_column', :action => 'new'
      end
    end
  end

  def edit
    @metro_areas, @states = setup_locations_for(@user)
    #@avatar               = Photo.new
    @avatar               = (@user.avatar ||@user.build_avatar)
    load_tshirt_sizes
  end



  def dashboard
    @user = current_user
    @network_activity = @user.network_activity
    @recommended_posts = @user.recommended_posts
    @popular_tags = popular_tags(30).to_a
    @active_users = User.active.find_by_activity({:limit => 5, :require_avatar => false})
    @featured_writers = User.find_featured

  end

  #def popular_tags(limit = nil, order = ' tags.name ASC', type = nil)
  #  sql = "SELECT tags.id, tags.name, count(*) AS count
  #    FROM taggings, tags
  #    WHERE tags.id = taggings.tag_id "
  #  sql += " AND taggings.taggable_type = '#{type}'" unless type.nil?
  #  sql += " GROUP BY tags.id, tags.name"
  #  sql += " ORDER BY #{order}"
  #  sql += " LIMIT #{limit}" if limit
  #  Tag.find_by_sql(sql).sort{ |a,b| a.name.downcase <=> b.name.downcase}
  #end


  def show
    # deactivated accounts should not be viewable
    if @user.activated_at.nil?
      redirect_to login_path
      return
    end

    @friend_count               = @user.accepted_friendships.count
    @accepted_friendships       = @user.accepted_friendships.limit(5).to_a.collect{|f| f.friend }
    @pending_friendships_count  = @user.pending_friendships.count()

    @chat_admin_list = ''
    if current_user
      User.where("chat_admin = true").each do |admin|
        if current_user != admin
          if !@chat_admin_list.empty?
            @chat_admin_list << ', '
          end
          @chat_admin_list << admin.login_slug
        end
      end
    end

    #@accepted_friendships_with_avatars = []
    #@accepted_friendships.each do |f|
    #  if !f.avatar_id.nil?
    #    @accepted_friendships_with_avatars << f
    #    end
    #end

    @comments       = @user.comments.limit(10).order('created_at DESC')
    @photo_comments = Comment.find_photo_comments_for(@user)
    @users_comments = Comment.find_comments_by_user(@user).limit(5)

    @recent_posts   = @user.posts.recent.limit(5)
    #@clippings      = @user.clippings.limit(5)
    @comment        = Comment.new(params[:comment])

    if current_user && current_user == @user
      @photos = @user.photos.recent.limit(5)
    else
      @photos = @user.photos.where(:is_private => false).recent.limit(5)
    end

#    @my_activity = Activity.recent.by_users([@user.id]).find(:all, :limit => 10)

#    @system_announcement = Post.find(:all, :conditions => ["is_system_announcement = true"], :order => "updated_at desc", :limit => 1)

    update_view_count(@user) unless current_user && current_user.eql?(@user)
  end


  def signup_completed
    @user = User.find(params[:id])
    redirect_to home_path and return unless @user
     render :layout => 'single_column', :action => 'signup_completed'
  end


  #def forgot_password
  #  return unless request.post?
  #
  #  @user = User.active.find_by_email(params[:email])
  #  if @user && @user.reset_password
  #    UserNotifier.reset_password(@user).deliver
  #    @user.save_without_session_maintenance
  #    redirect_to login_url
  #    flash[:info] = :your_password_has_been_reset_and_emailed_to_you.l
  #  else
  #    redirect_to login_url
  #    flash[:error] = :sorry_we_dont_recognize_that_email_address.l
  #  end
  #end

  #def forgot_username
  #  return unless request.post?
  #
  #  if @user = User.active.find_by_email(params[:email])
  #    UserNotifier.forgot_username(@user).deliver
  #    redirect_to login_url
  #    flash[:info] = "Your login ID was emailed to you."
  #  else
  #    redirect_to login_url
  #    flash[:error] = :sorry_we_dont_recognize_that_email_address.l
  #  end
  #end



  def games_owned_and_registered_in(user)
    game_ids = []
    user.games.each do |g|
      game_ids << g.id
    end

    user.games_registered_in.each do |gri|
      game_ids << gri.id
    end

    return Game.where("id in (?)", game_ids)
  end

  def calendar
    user = User.find(params[:id])
    
    games = games_owned_and_registered_in(user)
    if games.where_sql.blank? # No search criteria
      calendar_conditions = '1'
    else
      calendar_conditions = games.where_sql.sub(/^WHERE/i,'')
    end

    @month = params[:month].to_i
    @year = params[:year].to_i
    @shown_month = Date.civil(@year, @month)
    @event_strips = Game.event_strips_for_month(@shown_month, :conditions => calendar_conditions )
  end


  def ical
    user = User.find(params[:id])

    @calendar = RiCal.Calendar
    @calendar.add_x_property 'X-WR-CALNAME', configatron.community_name
    @calendar.add_x_property 'X-WR-CALDESC', "#{configatron.community_name} games"
    games_owned_and_registered_in(user).each do |ce_event|
      rical_event = RiCal.Event do |event|
        event.dtstart = ce_event.start_at
        event.dtend = ce_event.end_at
        event.summary = ce_event.name
        coder = HTMLEntities.new
        event.description = (ce_event.description.blank? ? '' : Nokogiri::HTML(ce_event.description).text + "\n\n") + game_url(ce_event)
        event.location = game_url(ce_event)
      end
      @calendar.add_subcomponent rical_event
    end
    headers['Content-Type'] = "text/calendar; charset=UTF-8"
    render :text => @calendar.export_to, :layout => false
  end

   def membership
     if current_user
       @user = User.find(params[:id])

       if !(current_user.admin? || current_user == @user)
         flash[:error]= "You may not view other user's data."
         redirect_to home_url
         return
       end
     else
       redirect_to home_url
     end
   end

  def shipping_address
    if current_user
      @user = User.find(params[:id])

      if !(current_user.admin? || current_user == @user)
        flash[:error]= "You may not view other user's data."
        redirect_to home_url
        return
      end
      render 'address/shipping_address'
      return
    else
      redirect_to home_url
      return
    end
  end


  def update_shipping_address
    if current_user
      @user = User.find(params[:id])

      if !(current_user.admin? || current_user == @user)
        flash[:error]= "You may not view other user's data."
        redirect_to home_url
        return
      end
      if @user.save!
        flash[:notice]= "Shipping address saved."
        redirect_to user_shipping_address_url
      else
        flash[:error]= "You may not edit other user's data."
        redirect_to home_url
      end
    end
  end
#  def grant_achievement_for_booth_visit(user)
#    achievement = Achievement.find(BOOTH_VISIT_ACHIEVEMENT_ID)
#    grant_achievement(user, achievement)
#  end


  def tshirt_details
    if current_user
      @user = User.find(params[:id])

      @user.address ||= Address.new

      load_tshirt_sizes
    end
  end

  def load_tshirt_sizes
    #@tshirt_sizes = {1 => "Men's S",
    #                 2=> "Men's M",
    #                 3=> "Men's L",
    #                 4=> "Men's XL",
    #                 5=> "Men's XXL",
    #                 6=> "Women's XS",
    #                 7=> "Women's S",
    #                 8=> "Women's M",
    #                 9=> "Women's L"}

    @tshirt_sizes = {"Men's S" => "Men's S",
                     "Men's M" => "Men's M",
                     "Men's L" => "Men's L",
                     "Men's XL" => "Men's XL",
                     "Men's XXL" => "Men's XXL",
                     "Women's XS" => "Women's XS",
                     "Women's S" => "Women's S",
                     "Women's M" => "Women's M",
                     "Women's L" => "Women's L"}
  end

  def update_tshirt_details
    if current_user
      @user = User.find(params[:id])

      if !(current_user.admin? || current_user == @user)
        flash[:error]= "You may not edit other user's data."
        redirect_to home_url
        return
      end
      @user.tshirt_size = params[:user][:tshirt_size]
      @user.address.line_one = params[:user][:address][:line_one]
      @user.address.line_two = params[:user][:address][:line_two]
      @user.address.city = params[:user][:address][:city]
      @user.address.state = params[:user][:address][:state]
      @user.address.country = params[:user][:address][:country]
      @user.address.postal_code = params[:user][:address][:postal_code]
      @user.address.is_shipping = params[:user][:address][:is_shipping]

      #if @user.save!
      #  a = 1
      #end
      #
      #if @user.address.save!
      #  a = 2
      #end

      if @user.save! && @user.address.save!
        flash[:notice]= "Tshirt details saved."
        redirect_to user_tshirt_details_url
      else
        flash[:error]= "Tshirt detail save failed."
        redirect_to home_url
      end
    end
  end


  def assume
    user = User.find(params[:id])
    new_user_record = self.assume_user(user).record
    redirect_to user_path(new_user_record)
  end


  def sideload
    if !(params.has_key?(:hash) && params.has_key?(:email))
      flash[:error] = "This will go in your permanent record."
      redirect_to home_path
      return
    end

    sha2 = Digest::SHA2.new
    hash_input = params[:email] + D20PRO_SECRET
    sha2.update hash_input
    hash = sha2.hexdigest

    if hash != params[:hash]
      flash[:error] = "Your ticket is expired."
      redirect_to home_path
      return
    end

    @user = User.find_by_email(params[:email])

    if @user
      # anything to do for existing users???
    else
      @user = User.new()
      @user.role = Role[:member]
      @user.email = params[:email]
      @user.first_name = params[:first_name]
      @user.last_name = params[:last_name]
      @user.birthday = User.first.birthday
      @user.crypted_password = User.first.crypted_password
      @user.password_salt = User.first.password_salt
      @user.login = User.create_unique_login(params[:last_name])
      @user.activate
      @user.save!
    end

    #create_friendship_with_inviter(@user, params)
    #create_friendship_with_kieara(@user)

    #TODO d20pro-specific account activation welcome email

    #achievement = Achievement.find(D20PRO_REG_ACHIEVEMENT_ID)
    #@user.achievements << achievement

    #@user.save!

    # TODO log user in
    #Authlogic::Session::Base.controller = Authlogic::ControllerAdapters::RailsAdapter.new(self)
    @user_session = UserSession.create(@user)
    @user_session.save

    redirect_to games_path
  end


  protected
  def user_params
    params[:user].permit(:avatar_id, :company_name, :country_id, :description, :email,
                         :firstname, :fullname, :gender, :lastname, :login, :metro_area_id,
                         :middlename, :notify_comments, :notify_community_news,
                         :notify_friend_requests, :password, :password_confirmation,
                         :profile_public, :state_id, :stylesheet, :time_zone, :vendor, :zip,
                         :tag_list,
                         :first_name,
                         :last_name,
                         :notify_admin_blasts,
                         :notify_registrations,
                         :publisher_name,
                         :allow_fb_autopost_achievement_unlocked,
                         :allow_fb_autopost_new_friend,
                         {:avatar_attributes => [:id, :name, :description, :album_id, :user,
                                                 :user_id, :photo, :photo_remote_url]},
                         :birthday) if params[:user]
  end
end


