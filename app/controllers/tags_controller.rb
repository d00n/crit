class TagsController < BaseController
  require_from_ce('controllers/tags_controller')

  #before_filter :login_required, :only => [:manage, :edit, :update, :destroy]
  #before_filter :admin_required, :only => [:manage, :edit, :update, :destroy]
  #skip_before_filter :verify_authenticity_token, :only => 'auto_complete_for_tag_name'
  #
  #caches_action :show, :cache_path => Proc.new { |controller| controller.send(:tag_url, controller.params[:id]) }, :if => Proc.new{|c| c.cache_action? }
  #def cache_action?
  #  !logged_in? && params[:type].blank?
  #end

  #def auto_complete_for_tag_name
  #  #if !params[:id].blank? || !params[:tag_list].blank?
  #    #@tags = ActsAsTaggableOn::Tag.find(:all, :limit => 10, :conditions => [ 'LOWER(name) LIKE ?', '%' + (params[:id] || params[:tag_list]) + '%' ])
  #    #@tags = Tag.all(:conditions => [ 'LOWER(name) LIKE ?', '%' + (params[:id] || params[:tag_list]) + '%' ])
  #
  #    @tags = ActsAsTaggableOn::Tag.find(:all, :limit => 10, :conditions => [ 'LOWER(name) LIKE ?', '%' + (params[:id] || params[:tag_list]) + '%' ])
  #    render :inline => "<%= infrno_auto_complete_result(@tags, 'name') %>"
  #
  #
  #end

  
  def index  
    @tags = popular_tags(500).to_a
    #@character_tags = popular_tags(75, 'Character').to_a
    #@product_tags = popular_tags(75, 'Product').to_a
    #@game_tags = popular_tags(75, 'Game').to_a
    #@user_tags = popular_tags(75, 'User').to_a
    #@post_tags = popular_tags(75, 'Post').to_a
    #@photo_tags = popular_tags(75, 'Photo').to_a
    #@clipping_tags = popular_tags(75, 'Clipping').to_a
  end
  
  def show
    tag_array = ActsAsTaggableOn::TagList.from( URI::decode(params[:id]) )

    @tags = ActsAsTaggableOn::Tag.where('name IN (?)', tag_array)
    if @tags.nil? || @tags.empty?
      flash[:notice] = :tag_does_not_exists.l_with_args(:tag => tag_array)
      redirect_to :action => :index and return
    end

    @related_tags = @tags.first.related_tags
    @tags_raw = @tags.collect { |t| t.name } .join(',')
    @popular_tags = popular_tags(50)

    if params[:type]
      case params[:type]
        when 'Product', 'product'
          @products = @products = Product.recent.tagged_with(tag_array).page(params[:page]).per(30)
          @characters, @games, @posts, @photos, @users, @clippings = [], [], [], [], [], []
        when 'Character', 'character'
          @characters = @characters = Character.recent.tagged_with(tag_array).page(params[:page]).per(30)
          @products, @games, @posts, @photos, @users, @clippings = [], [], [], [], [], []
        when 'Game', 'games'
          @games = @games = Game.recent.tagged_with(tag_array).page(params[:page]).per(30)
          @products, @characters, @posts, @photos, @users, @clippings = [], [], [], [], [], []
        when 'Post', 'posts'
          @pages = @posts = Post.recent.tagged_with(tag_array).page(params[:page]).per(30)
          @products, @characters, @games, @photos, @users, @clippings = [], [], [], [], [], []
        when 'Photo', 'photos'
          @pages = @photos = Photo.recent.tagged_with(tag_array).page(params[:page]).per(30)
          @products, @characters, @games, @posts, @users, @clippings = [], [], [], [], [], []
        when 'User', 'users'
          @pages = @users = User.recent.tagged_with(tag_array).page(params[:page]).per(30)
          @products, @characters, @games, @posts, @photos, @clippings = [], [], [], [], [], []
        when 'Clipping', 'clippings'
          @pages = @clippings = Clipping.recent.tagged_with(tag_array).page(params[:page]).per(30)
          @products, @characters, @games, @posts, @photos, @users = [], [], [], [], []
      else
        @products, @characters, @games, @clippings, @posts, @photos, @users = [], [], [], [], [], [], []
      end
    else
      @products = Product.recent.limit(5).tagged_with(tag_array)
      @characters = Character.limit(5).tagged_with(tag_array)
      @games = Game.recent.limit(5).tagged_with(tag_array)
      @posts = Post.recent.limit(5).tagged_with(tag_array)
      @photos = Photo.recent.limit(5).tagged_with(tag_array)
      @users = User.recent.limit(5).tagged_with(tag_array).uniq
      #@clippings = Clipping.recent.limit(5).tagged_with(tag_array)
    end
  end

end
