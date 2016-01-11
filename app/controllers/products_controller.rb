class ProductsController < BaseController
  include Viewable
  
  #before_filter :login_required, :except => [:index, :show, :publisher_products]
  #before_filter :publisher_required, :only => [:manage_featured_products, :update_featured_products, :manage_catalog, :update_catalog, :new, :edit, :create, :update]
  cache_sweeper :taggable_sweeper, :only => [:activate, :update, :destroy]
  protect_from_forgery :only => [:create, :update, :destroy]

#  before_filter :route_everything_to_home_page
#
#  def route_everything_to_home_page
#    flash[:notice] = 'Product sections have been disabled while new catalog is being rolled out.'
#    redirect_to home_url
#  end
  
  def publisher_required
    return @current_user.publisher
  end
  
  uses_tiny_mce do
    {:only => [:new, :create, :update, :edit, :show ],
    :options => configatron.default_mce_options}
  end

  def manage_featured_products
    @products = @current_user.products 
        respond_to do |format|
      format.html { render :layout => 'application' }
    end
  end  
  
  def update_featured_products        
    params[:user][:product].each do |product_param|
    wd roduct = current_user.products.find(product_param.first)
      featured_product_rank = product_param.second[:featured_product_rank].to_i
      if featured_product_rank > 0
        product.featured_product_rank = product_param.second[:featured_product_rank].to_i
      else
        product.featured_product_rank = nil
      end
      product.save
    end
    
    redirect_to(@current_user)
  end  
  
  def manage_catalog
    @products = @current_user.products 
        respond_to do |format|
      format.html { render :layout => 'application' }
    end
  end
  
  def update_catalog       
    params[:user][:product].each do |product_param|
      product = current_user.products.find(product_param.first)
      catalog_rank = product_param.second[:catalog_rank].to_i
      if catalog_rank > 0
        product.catalog_rank = product_param.second[:catalog_rank].to_i
      else
        product.catalog_rank = nil
      end
      product.save
    end
    
    redirect_to(publisher_products_path(@current_user))
  end
  
  def remove_profile_photo
    @product = current_user.products.find(params[:id])
    @product.avatar = nil
    @product.save
    redirect_to(@product)
  end

  # GET /products/user/id
  def publisher_products
    @publisher = User.find(params[:id])
    @products = @publisher.products
    @popular_products = []

    respond_to do |format|
      format.html { render :layout => 'application' }
    end
  end  

  # GET /products
  # GET /products.xml
  def index
    products, @search = Product.search_conditions(params)

    @result_count = products.size.to_s
    @products = products.page(params[:page]).per(20)
    @publishers = User.publisher.order('publisher_name')

    if params[:new_game]
      @new_game = true
    end

    if params[:game_id]
      @game = Game.find_by_id(params[:game_id])
    end

    if params[:character_id]
      @character = Character.find_by_id(params[:character_id])
    end

    if params[:system_category_id]
      @system_category = SystemCategory.find_by_id(params[:system_category_id])
    end

    if !params[:publisher_id].blank?
      @publisher= User.find(params[:publisher_id])
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @products }
    end
  end

  def system_categories
    @product = Product.find(params[:id])
  end


  # GET /products/1
  # GET /products/1.xml
  def show
    
    @product = Product.find(params[:id])
    @comments = @product.comments.find(:all, :limit => 10, :order => 'created_at ')     
    
    @posts = @product.comments.find(:all, :limit => 10, :order => 'created_at')

    #@popular_posts = @category.posts.find(:all, :limit => 10, :order => "view_count DESC")
    #@popular_polls = Poll.find_popular_in_category(@category)
    #@rss_title = "#{configatron.community_name}: #{@category.name} "+:posts.l
    #@rss_url = category_path(@category, :format => :rss)    

    respond_to do |format|
      format.html { render :layout => 'application' }
      format.xml  { render :xml => @product }
    end
  end

  # GET /products/new
  # GET /products/new.xml
  def new
    @product = Product.new

    if params[:game_id]
      @game =  Game.find(params[:game_id])
    elsif params[:character_id]
      @character =  Character.find(params[:character_id])
    end

    @product.catalog_rank = 1
    @current_user.products.each do |product|
      if !product.catalog_rank.blank? and @product.catalog_rank <= product.catalog_rank
        @product.catalog_rank = product.catalog_rank + 1
      end
    end
      
    respond_to do |format|
      format.html { render :layout => 'application' }
      format.xml  { render :xml => @product }
    end
  end

  # GET /products/1/edit
  def edit
    @product = Product.find(params[:id])
    render :layout => 'application'
  end

  # POST /products
  # POST /products.xml
  def create
    @product = current_user.products.new(product_params)
    @product.tag_list = params[:product][:name]  + ", " + params[:tag_list]  

    respond_to do |format|
      if @product.save
        flash[:notice] = 'Product was successfully created.'
        format.html {
          if !params[:game_id].blank?
            @game = Game.find(params[:game_id])
            if @game
              @game.add_product(@product)
              render 'games/products'
              return
            end
          elsif !params[:character_id].blank?
            @character = Character.find(params[:character_id])
            if @character
              @character.add_product(@product)
              render 'characters/products'
              return
            end
          else
            redirect_to(@product)
          end }
        format.xml  { render :xml => @product, :status => :created, :location => @product }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @product.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /products/1
  # PUT /products/1.xml
  def update
    @product = Product.find(params[:id])
    if current_user.nil? || !(current_user == @product.owner || current_user.admin?)
      flash[:error] = 'You may not edit a product you do not own.'
      redirect_to product_url @product
      return
    end


    respond_to do |format|
      if @product.update_attributes(product_params)

        # Causes slug to be regenerated
        @product.name_slug = ''
        @product.save!

        flash[:notice] = 'Product was successfully updated.'
        format.html { redirect_to(@product) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @product.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.xml
  def destroy
    @product = current_user.products.find(params[:id])
    @product.destroy

    respond_to do |format|
      format.html { redirect_to(products_url) }
      format.xml  { head :ok }
    end
  end

  def update_views
    if logged_in?
      @product = Product.find(params[:id])
      updated = update_view_count(@product)
      render :text => updated ? 'updated' : 'duplicate'
      return
    end

    # not really a dup, but this isn't displayed anyway
    render :text => 'duplicate'
  end  
    
  
  def change_profile_photo
    @product = Product.find(params[:id])

    # TODO make this a before_filter
    if current_user && (current_user == @product.owner || current_user.admin?)
      @photo  = Photo.find(params[:photo_id])
      @product.avatar = @photo

      if @product.save!
        flash[:notice] = 'Product was successfully updated.'
        redirect_to publisher_product_path(@product.owner, @product)
      else
        format.html { render :action => "edit", :layout => 'application' }
      end
    else
      flash[:error] = "You can not edit this product."
      redirect_to publisher_product_path(@product.owner, @product)
      return
    end
    

  rescue ActiveRecord::RecordInvalid
    render :action => 'edit'
  end

  def pick_profile_photo
    @product = Product.find(params[:id])

    if current_user && (current_user == @product.owner || current_user.admin?)
      @user = @product.owner
      @photos = current_user.photos.recent.page(params[:page]).per(100)

      @rss_title = "#{configatron.community_name}: #{@user.login}'s photos"
      @rss_url = user_photos_path(@user,:format => :rss)

      respond_to do |format|
        format.html { render :layout => 'application' }
        format.rss {
          render_rss_feed_for(@photos,
                              { :feed => {:title => @rss_title, :link => url_for(:controller => 'photos', :action => 'index', :user_id => @user) },
                                :item => {:title => :name,
                                          :description => Proc.new {|photo| description_for_rss(photo)},
                                          :link => Proc.new {|photo| user_photo_url(photo.user, photo)},
                                          :pub_date => :created_at} })

        }
        format.xml { render :action => 'index.rxml', :layout => false}
      end
      return

    else
      flash[:error] = "You can not edit this product."
      redirect_to publisher_product_path(@product.owner, @product)
      return
    end

  end

  def games
    @product = Product.find(params[:product_id])
    @comments = @product.comments.find(:all, :limit => 10, :order => 'created_at ')
  end

  def characters
    @product = Product.find(params[:product_id])
    @comments = @product.comments.find(:all, :limit => 10, :order => 'created_at ')
  end

  protected
  def product_params
    params[:product].permit(:name,
        :key_creatives,
        :manufacturer,
        :product_code,
        :isbn,
        :price,
        :date_available,
        :purchase_book_url,
        :purchase_pdf_url,
        :catalog_rank,
        :featured_product_rank,
        :is_core_rulebook,
        :summary,
        :tag_list,
        :description)

  end
end
