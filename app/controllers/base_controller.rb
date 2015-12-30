class BaseController < ApplicationController
  require_from_ce('controllers/base_controller')

  include AuthenticatedSystem
  include LocalizedApplication
  around_filter :set_locale
  before_filter :set_timezone
  skip_before_filter :verify_authenticity_token, :only => :footer_content

  helper_method :commentable_url
  helper_method :nick

  # caching site_index makes the authenticity_token stale for the login form
  #caches_action :site_index, :footer_content, :if => Proc.new{|c| c.cache_action? }
  caches_action :site_index, :footer_content, :if => false
  #caches_action :only => :footer_content, :if => Proc.new{|c| c.cache_action? }
  #def cache_action?
  #  !logged_in? && controller_name.eql?('base') && params[:format].blank?
  #end

  def keep_me_posted
    br = BetaRequest.new()
    br.email = params[:email]
    br.save
    flash[:notice] = "Thanks, we'll be in touch!"
    redirect_to teaser_path
  end

#  def signup
#    redirect_to home_url and return if logged_in?
#  end
#
#  def signup_publisher
#    redirect_to home_url and return if logged_in?
#  end


  #def rss_site_index
  #  redirect_to :controller => 'base', :action => 'site_index', :format => 'rss'
  #end
  #
  #def plaxo
  #  render :layout => false
  #end

  def welcome
    logger.info('Base.welcome params[:facebook]='+params[:facebook].to_s)
  end

  def flgs
    @games_starting_soon = []
    if current_user
      @games_starting_soon = current_user.games_starting_soon
      grant_achievement_for_booth_visit(current_user)
    end

    @sample_game = Game.find(19)
    @popular_tags = popular_tags(30).to_a
    @site_tour_post = Post.find(423)
    @game_table_tour_post = Post.find(532)



    respond_to do |format|
      format.html { get_additional_homepage_data }
    end
  end

  def site_index

    @games_starting_soon = []
    if current_user
      @games_starting_soon = current_user.games_starting_soon
      grant_achievement_for_booth_visit(current_user)
    end

    #@sample_game = []
    #@recent_posts = []
    #@popular_tags = []
    #@recent_photos = []
    #@site_tour_post = []
    #@game_table_tour_post = []
    #
    #@recent_forum_posts = []
    #
    #@system_announcement = []

    @sample_game = Game.find(19)
    @recent_posts = Post.recent.limit(5)
    @popular_tags = popular_tags(30).to_a
    @recent_photos = Photo.recent.where('user_id is not null and is_private is false').limit(10)
    @site_tour_post = Post.find(423)
    @game_table_tour_post = Post.find(532)

    @recent_forum_posts = SbPost.with_query_options.recent.limit(5)

    @system_announcement = Post.system_announcement

    respond_to do |format|
      format.html { get_additional_homepage_data }
    end
  end

  def whats_new
    @recent_posts = Post.find_recent
    @popular_tags = popular_tags(30).to_a
    @recent_photos = Photo.find_recent(:limit => 10)

    @recent_forum_posts = SbPost.with_query_options.find(:all, :limit => 5, :order => "created_at DESC")


    @rss_title = "#{configatron.community_name} "+:recent_posts.l
    @rss_url = rss_url
    respond_to do |format|
      format.html {
        get_additional_homepage_data
        render 'site_index'
        }
      format.rss do
        render_rss_feed_for(@posts, { :feed => {:title => "#{configatron.community_name} "+:recent_posts.l, :link => recent_url},
                              :item => {:title => :title,
                                        :link =>  Proc.new {|post| user_post_url(post.user, post)},
                                         :description => :post,
                                         :pub_date => :published_at}
          })
      end
    end
  end


  def gencon_live_stream
    render :layout => "gencon_ls_layout"
  end


  def admin_required
    current_user && current_user.admin? ? true : access_denied
  end

  def admin_or_moderator_required
    current_user && (current_user.admin? || current_user.moderator?) ? true : access_denied
  end


  #def find_user
  #  begin
  #    @user = User.active.find(params[:user_id] || params[:id])
  #    @is_current_user = (@user && @user.eql?(current_user))
  #    unless logged_in? || @user.profile_public?
  #      flash[:error] = :this_users_profile_is_not_public_youll_need_to_create_an_account_and_log_in_to_access_it.l
  #      redirect_to users_url
  #    else
  #      return @user
  #    end
  #  rescue
  #    flash[:error] = "Access denied"
  #    redirect_to users_url
  #  end
  #end
  #
  #def require_current_user
  #  @user ||= User.find(params[:user_id] || params[:id] )
  #  unless admin? || (@user && (@user.eql?(current_user)))
  #    redirect_to :controller => 'sessions', :action => 'new' and return false
  #  end
  #  return @user
  #end
  #
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
  #
  #
  #def get_recent_footer_content
  #  #@recent_clippings = Clipping.find_recent(:limit => 10)
  #  @recent_photos = Photo.find_recent(:limit => 10)
  #  @recent_comments = Comment.find_recent(:limit => 13)
  #  @popular_tags = popular_tags(30)
  #  @recent_activity = User.recent_activity(:size => 15, :current => 1)
  #  @popular_posts = Post.find_popular({:limit => 5, :since => 3.days})
  #end

  def get_additional_homepage_data
    #@sidebar_right = true
    #@homepage_features = HomepageFeature.find_features
    #@homepage_features_data = @homepage_features.collect {|f| [f.id, f.photo.url(:large) ]  }

    @active_users = User.active.find_by_activity({:limit => 5, :require_avatar => false})
    #@featured_writers = User.find_featured

    #@featured_posts = Post.find_featured

    #@topics = Topic.find(:all, :limit => 5, :order => "replied_at DESC")

    #@active_contest = Contest.get_active
    #@popular_posts = Post.find_popular({:limit => 5, :since => 30.days})
    #@popular_polls = Poll.find_popular(:limit => 8)
  end


  def commentable_url(comment)
    if comment.recipient && comment.commentable
      if comment.commentable_type != "User"
        polymorphic_url([comment.recipient, comment.commentable])+"#comment_#{comment.id}"
      elsif comment
        user_url(comment.recipient)+"#comment_#{comment.id}"
      end
    elsif comment.commentable
      polymorphic_url(comment.commentable)+"#comment_#{comment.id}"
    end
  end

  def commentable_comments_url(commentable)
    if commentable.owner && commentable.owner != commentable
      "#{polymorphic_path([commentable.owner, commentable])}#comments"
    else
      "#{polymorphic_path(commentable)}#comments"
    end
  end

  def valid_user_required
    user = User.find(params[:id])
    if !user
      flash[:error] = 'User not found.'
      redirect_to home_url
    end
  end

  def valid_game_required
    game = Game.find_by_id(params[:id])
    if !game
      flash[:error] = 'Game not found.'
      redirect_to games_url
    end
  end

  def valid_character_required
    char = Character.find_by_id(params[:id])
    if !char
      flash[:error] = 'Character not found.'
      redirect_to characters_url
    end
  end

#  def valid_topic_required
#    topic = Topic.find_by_id(params[:forum_id])
#    if !topic
#      flash[:error] = 'Topic not found.'
#      redirect_to recent_forum_posts_url
#    end
#  end
#
#  def valid_forum_required
#    forum = Forum.find_by_id(params[:id])
#    if !forum
#      flash[:error] = 'Forum not found.'
#      redirect_to recent_forum_posts_url
#    end
#  end

  def grant_achievement_for_booth_visit_without_notification(user)
    if BOOTH_VISIT_ACHIEVEMENT_ENABLED && request.remote_ip.starts_with?(BOOTH_VISIT_REMOTE_IP)
      achievement = Achievement.find(BOOTH_VISIT_ACHIEVEMENT_ID)
      if !user.achievements.include?achievement
        user.achievements << achievement
      end
    end
  end


  def grant_achievement_for_booth_visit(user)
    if BOOTH_VISIT_ACHIEVEMENT_ENABLED && request.remote_ip.starts_with?(BOOTH_VISIT_REMOTE_IP)
      achievement = Achievement.find(BOOTH_VISIT_ACHIEVEMENT_ID)
      grant_achievement(user, achievement)
    end
  end

  def grant_achievement(user, achievement)
    unlocked_achievement = UnlockedAchievement.where(:user_id => user.id, :achievement_id => achievement.id).first

    if unlocked_achievement
      unlocked_achievement.level += 1
      unlocked_achievement.save!
      UserNotifier.achievement_leveled_notice(achievement, user).deliver
    else
      unlocked_achievement = UnlockedAchievement.create
      achievement.unlocked_achievements << unlocked_achievement

      user.unlocked_achievements << unlocked_achievement

      unlocked_achievement.level = 1
      unlocked_achievement.grantor_id = current_user.id
      unlocked_achievement.save!

      UserNotifier.achievement_granted_notice(achievement, user).deliver
    end

    begin
      facebook_auth = user.authorizations.find_by_provider('facebook')
      if !facebook_auth.nil?
       fb_user = FbGraph::User.me(facebook_auth.access_token)

        if !fb_user.nil?  && user.allow_fb_autopost_achievement_unlocked && user.last_fb_autopost < Time.now.utc - 1.day
          fb_user.feed!(
            :message => "I unlocked the #{achievement.name} achievement on #{configatron.community_name}",
            :picture => APP_URL + achievement.thumb.url,
            :link => achievement_url(achievement),
            :name => "#{achievement.name}",
            :description => "#{achievement.description}"
          )

          user.last_fb_autopost = Time.now.utc
          user.save
        end
      end
    rescue
      logger.error "Could not deliver achievement granted feed story to Facebook. Error: #{$!}"
    end

    return true
  end

  def create_friendship_with_kieara(user)
    kieara = User.find(5)

    if kieara && kieara.can_request_friendship_with(user)
      accepted    = FriendshipStatus[:accepted]

      @friendship = Friendship.new(:user_id => kieara.id,
        :friend_id => user.id,
        :friendship_status => accepted,
        :initiator => true)

      reverse_friendship = Friendship.new(:user_id => user.id,
        :friend_id => kieara.id,
        :friendship_status => accepted )

      @friendship.save
      reverse_friendship.save
    end
  end

  def post_to_facebook_user_joined_infrno(user)
    if user.nil?
      return
    end

    if user.posted_to_facebook_user_joined_infrno
      return
    end

    facebook_auth = user.authorizations.find_by_provider('facebook')
    if facebook_auth.nil?
      return
    end

    fb_user = FbGraph::User.me(facebook_auth.access_token)
    if fb_user.nil?
      return
    end

    fb_user.feed!(
      :message => "#{user.first_name} is playing D&D-style RPGs online using Infrno. Come play with #{user.first_name}, and other gamers from around the world!",
      :picture => APP_URL + User.find(5).avatar_photo_url(:thumb),
      :link => home_url,
      :name => 'http://www.infrno.net',
      :caption => 'Facebook for the D&D crowd, minus farmville, plus a virtual game table.',
      :description => "Infrno is a place to play any tabletop, pen-and-paper RPG on a virtual game table. Can't get your old gaming crew together IRL? Looking for new people to play with? Infrno has video chat, a die roller, and a shared whiteboard, all for FREE!"
    )

    user.posted_to_facebook_user_joined_infrno = true
    user.save

  end

  def fb_wall_post(user, message, picture, link, name, description)
    begin
      facebook_auth = user.authorizations.find_by_provider('facebook')
      if !facebook_auth.nil?
        fb_user = FbGraph::User.me(facebook_auth.access_token)

        if !fb_user.nil?
          fb_user.feed!(
              :message => message,
              :picture => picture,
              :link => link,
              :name => name,
              :description => description
          )

          user.last_fb_autopost = Time.now.utc
          user.save
        end
      end
    rescue
      logger.error "fb_wall_post: Could not deliver feed story to Facebook. Error: #{$!}"
    end
  end

  def seo_game_path(game)
    if game.products.any?
      return publisher_product_game_path(game.products.first.owner, game.products.first, game)
    else
      return game_path(game)
    end
  end

  def seo_character_path(character)
    if character.products.any?
      return publisher_product_character_path(character.products.first.owner, character.products.first, character)
    else
      return character_path(character)
    end
  end

  def nick
    if (current_user.nil?)
      return "guest"
    else
      return current_user.login
    end
  end

  private

  def set_timezone
    #if logged_in?
    if (defined? current_user)
      Time.zone = current_user.try(:time_zone)
    end
  end

end
