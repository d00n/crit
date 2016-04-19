include ActionView::Helpers::SanitizeHelper

class AchievementsController < BaseController

  before_filter :login_required, :only => [:select, :accept, :deny, :grant, :revoke, :remove, :new, :edit, :create, :update, :destroy]
  before_filter :valid_game_required, :only => [:select_game]
  before_filter :valid_character_required, :only => [:select_character]

  uses_tiny_mce do
    {:only => [:new, :create, :update, :edit],
    :options => configatron.default_mce_options }
  end


  # GET /achievements
  # GET /achievements.xml
  def index
    @achievements = Achievement.all

    respond_to do |format|
      format.html { 
        get_additional_homepage_data
        render :layout => 'application' }
      format.xml  { render :xml => @achievements }
    end
  end

  # GET /achievements/1
  # GET /achievements/1.xml
  def show
    @achievement = Achievement.find(params[:id])

    respond_to do |format|
      format.html { render :layout => 'application' }
      format.xml  { render :xml => @achievement }
    end
  end

  # GET /achievements/new
  # GET /achievements/new.xml
  def new
    if !current_user.admin? && current_user.membership_level < 1
      flash[:error] = "Granting achievements is a premium feature, upgrade now!"
      redirect_to home_path
      return
    end

    @achievement = Achievement.new
    @sample_achievements = Achievement.first(3)

    respond_to do |format|
      format.html { render :layout => 'application' }
      format.xml  { render :xml => @achievement }
    end
  end

  # GET /achievements/1/edit
  def edit
    @achievement = Achievement.find(params[:id])

    if @achievement.has_been_accepted && !current_user.achievement_admin
      render 'frozen'
      return
    end

    respond_to do |format|
      format.html { render :layout => 'application' }
    end
  end

  # POST /achievements
  # POST /achievements.xml
  def create
    @achievement = Achievement.new(achievement_params)
    @sample_achievements = Achievement.first(3)

    @achievement.owner = current_user

    respond_to do |format|
      if @achievement.save
        flash[:notice] = 'Achievement was successfully created.'
        format.html { redirect_to(@achievement) }
        format.xml  { render :xml => @achievement, :status => :created, :location => @achievement }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @achievement.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /achievements/1
  # PUT /achievements/1.xml
  def update
    @achievement = Achievement.find(params[:id])

    if @achievement.has_been_accepted && !current_user.achievement_admin
      render 'frozen'
      return
    end


    respond_to do |format|
      if @achievement.update_attributes(achievement_params)
        flash[:notice] = 'Achievement was successfully updated.'
        format.html { redirect_to(@achievement) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @achievement.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /achievements/1
  # DELETE /achievements/1.xml
  def destroy
    @achievement = Achievement.find(params[:id])

    # TODO make this a before_filter
    if current_user != @achievement.owner
      flash[:error] = "You may not edit this @achievement."
      redirect_to achievement_path(@achievement)
      return
    end

    @achievement.destroy

    respond_to do |format|
      format.html { redirect_to(achievements_url) }
      format.xml  { head :ok }
    end
  end


  def unlocked_user
    @user= User.find(params[:id])

    @pending = []
    @user.pending_achievements.each do |pa|
      if current_user && (current_user == @user || current_user == pa.grantor || current_user.admin?)
        @pending << pa
      end
    end

    @characters_with_pending = []
    @characters_with_accepted = []
    @games_with_pending = []
    @games_with_accepted = []

    if current_user && (current_user == @user || current_user.admin?)
      @user.games.each do |game|
        if game.pending_achievements.any?
          @games_with_pending << game
        end
        if game.accepted_achievements.any?
          @games_with_accepted << game
        end
      end

      @user.characters.each do |char|
        if char.pending_achievements.any?
          @characters_with_pending << char
        end
        if char.accepted_achievements.any?
          @characters_with_accepted << char
        end
      end
    end
  end

  def unlocked_character
    @character= Character.find(params[:id])

    @pending = []
    @character.pending_achievements.each do |pa|
      if current_user && (current_user == @character.user || current_user == pa.grantor || current_user.admin?)
        @pending << pa
      end
    end
  end

  def unlocked_game
    @game= Game.find(params[:id])

    @pending = []
    @game.pending_achievements.each do |pa|
      if current_user && (current_user == @game.user || current_user == pa.grantor || current_user.admin?)
        @pending << pa
      end
    end

  end

  def select_user
    @user= User.find(params[:id])
    @kiearas_achievements = User.find(5).authored_achievements
  end

  def select_game
    @game= Game.find(params[:id])
    @kiearas_achievements = User.find(5).authored_achievements
  end

  def select_character
    @character= Character.find(params[:id])
    @kiearas_achievements = User.find(5).authored_achievements
  end

  def authored
    @user= User.find(params[:id])
  end

  def manage
    
  end

  def grant
     # TODO make this a before_filter
    if !current_user.admin? && current_user.membership_level < 1
      flash[:error] = "Granting achievements is a premium feature, upgrade now!"
      redirect_to home_url
      return
    end

    if params[:recipient_type] == 'user'
      @user = User.find(params[:recipient_id])
      @grantee = @user
      unlocked_achievement = UnlockedAchievement.where(:user_id =>params[:recipient_id], :achievement_id => params[:id]).first
    elsif params[:recipient_type] == 'game'
      @game = Game.find(params[:recipient_id])
      @grantee = @game.owner
      unlocked_achievement = UnlockedAchievement.where(:game_id => params[:recipient_id], :achievement_id => params[:id]).first
    elsif params[:recipient_type] == 'character'
      @character = Character.find(params[:recipient_id])
      @grantee = @character.owner
      unlocked_achievement = UnlockedAchievement.where(:character_id => params[:recipient_id], :achievement_id => params[:id]).first
    end

    @achievement = Achievement.find(params[:id])
    # Is achievement public, or owned by current_user?

    if unlocked_achievement
      unlocked_achievement.level += 1
      unlocked_achievement.save!

      if @user
        UserNotifier.achievement_leveled_notice(@achievement, @user).deliver
      elsif @game
        UserNotifier.achievement_leveled_notice(@achievement, @game.owner).deliver
      elsif @character
        UserNotifier.achievement_leveled_notice(@achievement, @character.owner).deliver
      end

      flash[:notice] = "Achievement leveled up to #{unlocked_achievement.level}"
    else
      unlocked_achievement = UnlockedAchievement.create
      @achievement.unlocked_achievements << unlocked_achievement
      
      if @user
        @user.unlocked_achievements << unlocked_achievement
      elsif @game
        @game.unlocked_achievements << unlocked_achievement
      elsif @character
        @character.unlocked_achievements << unlocked_achievement
      end
      
      unlocked_achievement.level = 1
      unlocked_achievement.grantor_id = current_user.id
      unlocked_achievement.save!
      
      UserNotifier.achievement_granted_notice(@achievement, @grantee).deliver
      flash[:notice] = "Achievement granted."
    end



    if unlocked_achievement.achievement.owner != current_user
      unlocked_achievement.achievement.total_levels_granted_by_non_author += 1
      unlocked_achievement.save!
      UserNotifier.achievement_granted_by_non_author_notice(unlocked_achievement, unlocked_achievement.achievement.owner).deliver
    end

    path = fetch_return_path(unlocked_achievement)
    redirect_to path
  end

  def accept
    unlocked_achievement = UnlockedAchievement.find(params[:ua_id])

    if !unlocked_achievement || !current_user
      flash[:error] = "Access violation"
      redirect_to home_url
      return
    end

    return_path = fetch_return_path(unlocked_achievement)

    if !return_path
      flash[:error] = "Return path lookup failure"
      redirect_to home_url
      return
    end

    if !can_current_user_modify(unlocked_achievement)
      flash[:error] = "You do not have permission to accept this achievement."
      redirect_to return_path
      return
    end

    unlocked_achievement.accepted = true;
    unlocked_achievement.save!

    if unlocked_achievement.user
      @user = unlocked_achievement.user
    elsif unlocked_achievement.game
      @user = unlocked_achievement.game.owner
    elsif unlocked_achievement.character
      @user = unlocked_achievement.character.owner
    end

    UserNotifier.achievement_accepted_notice(unlocked_achievement.achievement, unlocked_achievement.grantor, @user).deliver



    begin
      facebook_auth = @user.authorizations.find_by_provider('facebook')

      if !facebook_auth.nil?
       fb_user = FbGraph::User.me(facebook_auth.access_token)

        @achievement = unlocked_achievement.achievement

        if !fb_user.nil?  && @user.allow_fb_autopost_achievement_unlocked && @user.last_fb_autopost < Time.now.utc - 1.day

          if @achievement.facebook_post_message && @achievement.facebook_post_message.length > 0
            message = @achievement.facebook_post_message
          else
            message = "#{current_user.first_name} unlocked the #{@achievement.name} achievement on Infrno.net!"
          end

          if @achievement.facebook_post_caption && @achievement.facebook_post_caption.length > 0
            caption = @achievement.facebook_post_caption
          else
            caption = "Nobody loves role players like Infrno does, and it's FREE! Come roll some dice with us!"
          end

          if @achievement.facebook_post_caption  && @achievement.facebook_post_caption.length > 0
            description = @achievement.facebook_post_description
          else
            description = strip_tags(@achievement.description)
          end

          if description.length < 160
            description += " #{configatron.meta_description}"
          end


          fb_user.feed!(
            :message => "#{message}",
            :picture => APP_URL + @achievement.thumb.url,
            :link => achievement_url(@achievement),
            :name => "#{@achievement.name}",
            :caption => "#{caption}",
            :description => "#{description}"
          )

          @user.last_fb_autopost = Time.now.utc
          @user.save

          logger.info "Facebook wall post success: #{user_url @user}, #{achievement_url @achievement}"
          flash[:notice] = "Achievement acccepted."
        end
      end
    rescue
      logger.error "Could not deliver achievement granted feed story to Facebook. Error: #{$!}"
      flash[:error] = "Could not deliver achievement granted feed story to Facebook. Error: #{$!}"
      redirect_to unlocked_user_achievements_path(@user)
      return
    end

    redirect_to return_path
  end

  def deny
    unlocked_achievement = UnlockedAchievement.find(params[:ua_id])

    if !unlocked_achievement || !current_user
      flash[:error] = "Access violation"
      redirect_to home_url
      return
    end

    return_path = fetch_return_path(unlocked_achievement)

    if !return_path
      flash[:error] = "Return path lookup failure"
      redirect_to home_url
      return
    end

    if can_current_user_modify(unlocked_achievement)
      unlocked_achievement.destroy
      flash[:notice] = "Achievement declined."
    else
      flash[:error] = "Unlocked achievement record not found."
    end

    redirect_to return_path
  end

  def revoke
    unlocked_achievement = UnlockedAchievement.find(params[:ua_id])

    if !unlocked_achievement || !current_user
      flash[:error] = "Access violation"
      redirect_to home_url
      return
    end

    return_path = fetch_return_path(unlocked_achievement)

    if !return_path
      flash[:error] = "Return path lookup failure"
      redirect_to home_url
      return
    end

    if can_current_user_modify(unlocked_achievement)
      if unlocked_achievement.user
        @user = unlocked_achievement.user
      elsif unlocked_achievement.game
        @user = unlocked_achievement.game.owner
      elsif unlocked_achievement.character
        @user = unlocked_achievement.character.owner
      end

      UserNotifier.achievement_revoked_notice(unlocked_achievement.achievement, @user).deliver

      unlocked_achievement.destroy
      flash[:notice] = "Achievement revoked."
    else
      flash[:error] = "Unlocked achievement record not found."
    end


    redirect_to return_path
  end

  def remove
    unlocked_achievement = UnlockedAchievement.find(params[:ua_id])

    if !unlocked_achievement || !current_user
      flash[:error] = "Access violation"
      redirect_to home_url
      return
    end

    return_path = fetch_return_path(unlocked_achievement)

    if !return_path
      flash[:error] = "Return path lookup failure"
      redirect_to home_url
      return
    end

    if can_current_user_modify(unlocked_achievement)
      unlocked_achievement.destroy
      flash[:notice] = "Achievement removed."
    else
      flash[:error] = "Unlocked achievement record not found."
    end

    redirect_to return_path
  end

  def fetch_return_path(unlocked_achievement)

    if request.referer.starts_with?(APP_URL+'/users/')
      if unlocked_achievement.character
        return_path = unlocked_user_achievements_path(unlocked_achievement.character.user)
      elsif unlocked_achievement.game
        return_path = unlocked_user_achievements_path(unlocked_achievement.game.user)
      else
        return_path = unlocked_user_achievements_path(unlocked_achievement.user)
      end
    elsif request.referer.starts_with?(APP_URL+'/games/')
      return_path = unlocked_game_achievements_path(unlocked_achievement.game)
    elsif request.referer.starts_with?(APP_URL+'/characters/')
      return_path = unlocked_character_achievements_path(unlocked_achievement.character)
    end

    return return_path
  end

  def can_current_user_modify(unlocked_achievement)
    if current_user &&
        unlocked_achievement.grantor == current_user ||
        unlocked_achievement.user == current_user ||
        (unlocked_achievement.game &&  unlocked_achievement.game.user == current_user) ||
        (unlocked_achievement.character &&  unlocked_achievement.character.user == current_user) ||
       current_user.admin?

     return true
    else
      return false
    end
  end

  def leaderboard_top_by_count
    user_ids_and_counts = UnlockedAchievement.user_winners.order("count_all desc").count(group: :user_id).first(50)
    @winners= []
    user_ids_and_counts.each do |a|
      @winners << User.find(a[0])
    end
  end

  def leaderboard_top_by_level
    @unlocked_achievements = UnlockedAchievement.winners.where("user_id is not null and level > 1").limit(50)
  end

  def leaderboard_top_authors
    authors_ids_and_counts = Achievement.order("count_all desc").count(group: :user_id)
    @authors= []
    authors_ids_and_counts.each do |a|
      @authors << User.find(a[0])
    end
  end

  protected
  def achievement_params
    params[:achievement].permit(:id,
                        :name, :others_can_grant, :description,
                        :avatar, :thumb, :badge
                         ) if params[:achievement]
  end

end
