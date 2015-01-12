class PublishersController < BaseController

#  def index
#    @users, @search, @metro_areas, @states = User.search_conditions_with_metros_and_states(params)
#
#    @popular_tags = popular_tags(30).to_a
#    @users_found = @users.publisher.includes(:tags).count
#    @users = @users.publisher.includes(:tags).page(params[:page]).per(20)
#
#    @tags = User.tag_counts :limit => 10
#  end
#
#
#  def show
#    @user = User.find(params[:id])
#
#    @friend_count               = @user.accepted_friendships.count
#    @accepted_friendships       = @user.accepted_friendships.find(:all, :limit => 5).collect{|f| f.friend }
#    @pending_friendships_count  = @user.pending_friendships.count()
#
#    @chat_admin_list = ''
#    if current_user
#      User.where("chat_admin = true").each do |admin|
#        if current_user != admin
#          if !@chat_admin_list.empty?
#            @chat_admin_list << ', '
#          end
#          @chat_admin_list << admin.login_slug
#        end
#      end
#    end
#
#    #@accepted_friendships_with_avatars = []
#    #@accepted_friendships.each do |f|
#    #  if !f.avatar_id.nil?
#    #    @accepted_friendships_with_avatars << f
#    #    end
#    #end
#
#    @comments       = @user.comments.find(:all, :limit => 100, :order => 'created_at')
#    @photo_comments = Comment.find_photo_comments_for(@user)
#    @users_comments = Comment.find_comments_by_user(@user).limit(5)
#
#    @recent_posts   = @user.posts.find(:all, :limit => 5, :order => "published_at DESC")
#    #@clippings      = @user.clippings.find(:all, :limit => 5)
#    @comment        = Comment.new(params[:comment])
#
#    if current_user && current_user == @user
#      @photos = @user.photos.recent.limit(5)
#    else
#      @photos = @user.photos.where(:is_private => false).recent.limit(5)
#    end
#
##    @my_activity = Activity.recent.by_users([@user.id]).find(:all, :limit => 10)
#
##    @system_announcement = Post.find(:all, :conditions => ["is_system_announcement = true"], :order => "updated_at desc", :limit => 1)
#
#    update_view_count(@user) unless current_user && current_user.eql?(@user)
#  end



end


