class PostsController < BaseController
  require_from_ce('controllers/posts_controller')

  before_filter :valid_game_required, :only => [:game_index]
  before_filter :valid_character_required, :only => [:character_index]
  before_filter :private_filter, :only => [:show]

  def character_index
    @character = Character.find_by_id(params[:id])

    if !@character.has_access(current_user)
      flash[:error] = "This is a private character"
      redirect_to private_game_path(@game)
      return
    end

    @user = @character.owner            
    @posts = @character.posts.recent.page(params[:page]).per(20)
    
    @is_current_user = @user.eql?(current_user)

    @popular_posts = @character.posts.find(:all, :limit => 10, :order => "view_count DESC")
    
    #@rss_title = "#{configatron.community_name}: #{@user.login}'s posts"
    #@rss_url = character_posts_path(@character,:format => :rss)
        
    respond_to do |format|
      format.html # index.rhtml
      format.rss {
        render_rss_feed_for(@posts,
           { :feed => {:title => @rss_title, :link => url_for(:controller => 'posts', :action => 'index', :character_id => @character) },
             :item => {:title => :title,
                       :description => :post,
                       :link => Proc.new {|post| character_post_url(post.character, post)},
                       :pub_date => :published_at} })
      }
    end
  end       

  def game_index
    @game = Game.find_by_id(params[:id])

    if !@game.has_access(current_user)
      flash[:error] = "This is a private game"
      redirect_to private_game_path(@game)
      return
    end

#    logger.info "id=#{params[:id]}"
    @user = @game.owner            
    @posts = @game.posts.recent.page(params[:page]).per(20)
    
    @is_current_user = @user.eql?(current_user)

    @popular_posts = @game.posts.find(:all, :limit => 10, :order => "view_count DESC")
    
    #@rss_title = "#{configatron.community_name}: #{@user.login}'s posts"
    #@rss_url = user_posts_path(@user,:format => :rss)
        
    respond_to do |format|
      format.html # index.rhtml
      format.rss {
        render_rss_feed_for(@posts,
           { :feed => {:title => @rss_title, :link => url_for(:controller => 'posts', :action => 'index', :game_id => @game) },
             :item => {:title => :title,
                       :description => :post,
                       :link => Proc.new {|post| game_post_url(post.game, post)},
                       :pub_date => :published_at} })
      }
    end
  end
  
  # GET /posts/new
  def new
    @user = current_user #User.find(params[:user_id])
    #@post = Post.new(params[:post])
    @post = Post.new
    @post.category = Category.find(params[:category_id]) if params[:category_id]
    @post.published_as = 'live'
    @categories = Category.all

    if !(params[:post][:game_id]).nil?
      @game = Game.find(params[:post][:game_id])
      if @game.owner == current_user
        @post.game = @game
      end
    end
    if !(params[:post][:character_id]).nil?
      @character = Character.find(params[:post][:character_id])
      if @character.owner == current_user
        @post.character = @character
      end
    end
  end
  

  # POST /posts
  # POST /posts.xml
  def create
    @user = current_user #User.find(params[:user_id])
    @post = Post.new(post_params)
    @post.user = @user
    @post.tag_list = params[:tag_list] || ''


    if ( params[:post][:game_id].to_i > 0 )
      @game = Game.find(params[:post][:game_id])
      if @game.owner == current_user
        @post.game = @game
      end
    end

    if ( params[:post][:character_id].to_i > 0 )
      @character = Character.find(params[:post][:character_id])
      if @character.owner == current_user
        @post.character = @character
      end
    end

    logger.info "create params: " + params.inspect

    if !current_user.admin?
      params[:is_system_announcement] = false
      params[:is_game_announcement] = false
    end
    
    respond_to do |format|
      if @post.save
        @post.create_poll(params[:poll], params[:choices]) if params[:poll]
        
        flash[:notice] = @post.category ? :post_created_for_category.l_with_args(:category => @post.category.name.singularize) : :your_post_was_successfully_created.l
        format.html { 
          if @post.is_live?
            if !@post.game.nil?
              redirect_to seo_game_path(@post.game)
            elsif !@post.character.nil?
              redirect_to seo_character_path(@post.character)
            else
              redirect_to user_path(@user)
            end
          else
            redirect_to manage_user_posts_path(@user)
          end
        }
        format.js
      else
        format.html { render :action => "new" }
        format.js        
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.xml
  def update
    @post = Post.unscoped.find(params[:id])
    @user = @post.user
    @post.tag_list = params[:tag_list] || ''

    if !current_user.admin?
      params[:is_system_announcement] = false
    end

    respond_to do |format|
      if @post.update_attributes(post_params)
        @post.update_poll(params[:poll], params[:choices]) if params[:poll]

        format.html { redirect_to user_post_path(@post.user, @post) }
      else
        format.html { render :action => "edit" }
      end
    end
  end
  
  def destroy
    @user = User.find(params[:user_id])
    @post = Post.find(params[:id])
    
    if @post.character
      @character = @post.character
    elsif @post.game
      @game = @post.game
    end       
    
    @post.destroy
    
    respond_to do |format|
      format.html { 
        flash[:notice] = :your_post_was_deleted.l
        
        if @character
          redirect_to character_post_path(@character)   
        elsif @game
          redirect_to game_post_path(@game)
        else
          redirect_to user_posts_path(@user)
        end 
        }
    end
  end  
    
  #def send_to_friend
  #  unless params[:emails]
  #    render :partial => 'posts/send_to_friend', :locals => {:user_id => params[:user_id], :post_id => params[:post_id]} and return
  #  end
  #  @post = Post.find(params[:id])
  #  if @post.send_to(params[:emails], params[:message], (current_user || nil))
  #    render :inline => "It worked!"
  #  else
  #    render :inline => "You entered invalid addresses: <ul>"+ @post.invalid_emails.collect{|email| '<li>'+email+'</li>' }.join+"</ul> Please correct these and try again.", :status => 500
  #  end
  #end

  def popular
    @posts = Post.find_popular({:limit => 15, :since => 30.days})
    @popular_tags = popular_tags(30).to_a
    #@monthly_popular_posts = Post.find_popular({:limit => 20, :since => 30.days})

    if current_user
      @games_starting_soon = current_user.games_starting_soon
    end
    @sample_game = Game.find(19)
    @site_tour_post = Post.find(423)
    @game_table_tour_post = Post.find(532)



    @active_users = User.active.find_by_activity({:limit => 5, :require_avatar => false})
    @featured_writers = User.find_featured
    
    @related_tags = Tag.find_by_sql("SELECT tags.id, tags.name, count(*) AS count 
      FROM taggings, tags 
      WHERE tags.id = taggings.tag_id GROUP BY tags.id, tags.name");

    @rss_title = "#{configatron.community_name} "+:popular_posts.l
    @rss_url = popular_rss_url    
    respond_to do |format|
      format.html # index.rhtml
      format.rss {
        render_rss_feed_for(@posts, { :feed => {:title => @rss_title, :link => popular_url},
          :item => {:title => :title, :link => Proc.new {|post| user_post_url(post.user, post)}, :description => :post, :pub_date => :published_at}
          })
      }
    end
  end
  
  def recent
    @posts = Post.recent.page(params[:page]).per(20)
    @popular_tags = popular_tags(30).to_a
    #@recent_clippings = Clipping.find_recent(:limit => 15)
    #@recent_photos = Photo.find_recent(:limit => 10)

    if current_user
      @games_starting_soon = current_user.games_starting_soon
    end
    @sample_game = Game.find(19)
    @site_tour_post = Post.find(423)
    @game_table_tour_post = Post.find(532)

    @active_users = User.active.find_by_activity({:limit => 5, :require_avatar => false})
    @featured_writers = User.find_featured
    
    @rss_title = "#{configatron.community_name} "+:recent_posts.l
    @rss_url = recent_rss_url
    respond_to do |format|
      format.html 
      format.rss {
        render_rss_feed_for(@posts, { :feed => {:title => @rss_title, :link => recent_url},
          :item => {:title => :title, :link => Proc.new {|post| user_post_url(post.user, post)}, :description => :post, :pub_date => :published_at}
          })
      }
    end    
  end
  
  def update_views
    if logged_in?
      @post = Post.find(params[:id])
      updated = update_view_count(@post)
      render :text => updated ? 'updated' : 'duplicate'
      return
    end
    
    # not really a dup, but this isn't displayed anyway
    render :text => 'duplicate'
  end

  def private_filter
    post = Post.find(params[:id])
    if post.nil?
      flash[:error] = "Post not found"
      redirect_to home_url
    end

    if !post.has_access(current_user)
      flash[:error] = "Post is private"
      redirect_to home_url
    end
  end
  

  
    
end
