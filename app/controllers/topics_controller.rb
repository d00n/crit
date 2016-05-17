class TopicsController < BaseController
  require_from_ce('controllers/topics_controller')

  # before_filter :find_forum_and_topic, :except => [:index, :new, :create]


  #def new
  #  @forum = Forum.find_by_id(params[:forum_id])
  #
  #  if @forum.nil?
  #    flash[:error] = 'No such forum.'
  #    redirect_to home_url
  #    return
  #  end
  #
  #  @topic = Topic.new(params[:topic])
  #  @topic.body = params[:topic][:body] if params[:topic]
  #end

  def show
    if @forum.nil? || @topic.nil?
      redirect_to home_url
      return
    end
    
    respond_to do |format|
      format.html do
        # see notes in base_controller.rb on how this works
        current_user.update_last_seen_at if logged_in?
        # keep track of when we last viewed this topic for activity indicators
        (session[:topics] ||= {})[@topic.id] = Time.now.utc if logged_in?
        # authors of topics don't get counted towards total hits
        @topic.hit! unless logged_in? and @topic.user == current_user

        @posts = @topic.sb_posts.recent.includes(:user).page(params[:page]).per(25)

        @voices = @posts.map(&:user)
        @voices.compact.uniq!
        @post   = SbPost.new(params[:post])
      end
      format.xml do
        render :xml => @topic.to_xml
      end
      format.rss do
        @posts = @topic.sb_posts.recent.limit(25)
        render :action => 'show', :layout => false, :formats => [:xml]
      end
    end
  end

  #def create
  #  @forum = Forum.find_by_id(params[:forum_id])
  #
  #  if @forum.nil?
  #    flash[:error] = 'No such forum.'
  #    redirect_to home_url
  #    return
  #  end
  #
  #  # this is icky - move the topic/first post workings into the topic model?
  #  Topic.transaction do
  #    @topic  = @forum.topics.new(params[:topic])
  #    assign_protected
  #    @post   = @topic.sb_posts.new(params[:topic])
  #    @post.topic=@topic
  #    @post.user = current_user
  #    # only save topic if post is valid so in the view topic will be a new record if there was an error
  #    @topic.tag_list = params[:tag_list] || ''
  #    @topic.save if @post.valid?
  #    @post.save
  #  end
  #  if !@topic.valid?
  #    respond_to do |format|
  #      format.html {
  #        render :action => 'new' and return
  #      }
  #    end
  #  else
  #    respond_to do |format|
  #      format.html {
  #        redirect_to forum_topic_path(@forum, @topic)
  #      }
  #      format.xml  {
  #        head :created, :location => forum_topic_url(:forum_id => @forum, :id => @topic, :format => :xml)
  #      }
  #    end
  #  end
  #end

  #protected

  #overide in your app
  #def authorized?
  #  #%w(new create).include?(action_name) || @topic.editable_by?(current_user)
  #  return true;
  #end

  #  def find_forum_and_topic
  #    @forum = Forum.find_by_id(params[:forum_id])
  #
  #    if @forum.nil?
  #      flash[:error] = 'No such forum.'
  #      redirect_to home_url
  #      return
  #    end
  #
  #    @topic = @forum.topics.find_by_id(params[:id]) if params[:id]
  #
  #    if @topic.nil?
  #      flash[:error] = 'No such topic.'
  #      redirect_to home_url
  #      return
  #    end
  #  end
end
