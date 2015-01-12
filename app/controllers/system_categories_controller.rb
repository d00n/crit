class SystemCategoriesController < BaseController
  include Viewable
  protect_from_forgery :only => [:create, :update, :destroy]

  #uses_tiny_mce(:only => [:new, :create, :update, :edit]) do
  #  configatron.default_mce_options.merge({:editor_selector => "rich_text_editor"})
  #end

  uses_tiny_mce do
    {:only => [:new, :create, :update, :edit, :welcome_about], :options => configatron.default_mce_options}
  end

  #def migrate
  #  system_categories, @search = SystemCategory.search_conditions(params)
  #
  #
  #  @result_count = system_categories.size.to_s
  #  @system_categories = system_categories.page(params[:page]).per(100)
  #
  #  @game_system = GameSystem.find(params[:game_system_id])
  #
  #  respond_to do |format|
  #    format.html
  #  end
  #end


  def add_game
    system_category = SystemCategory.find(params[:id])
    game = Game.find(params[:game_id])

    if current_user && (current_user == game.owner || current_user.admin?)
      system_category.products.each do |product|
        game.add_product(product)
      end
      flash[:notice] = 'Products added to game'
    else
      flash[:error] = 'You may not add products to a game you do not own'
    end

    redirect_to game
  end

  def add_character
    system_category = SystemCategory.find(params[:id])
    character = Character.find(params[:character_id])

    if current_user && (current_user == character.owner || current_user.admin?)
      system_category.products.each do |product|
        character.add_product(product)
      end
      flash[:notice] = 'Products added to character'
    else
      flash[:error] = 'You may not add products to a character you do not own'
    end

    redirect_to character
  end

  # GET /system_categories
  # GET /system_categories.xml
  def index
    system_categories, @search = SystemCategory.search_conditions(params)

    @result_count = system_categories.size.to_s
    @system_categories = system_categories.page(params[:page]).per(40)

    if params[:new_game]
      @new_game = true
    end

    if params[:game_system_id]
      @game_system = GameSystem.find(params[:game_system_id])
    end

    if params[:system_category_id]
      @system_category = SystemCategory.find(params[:system_category_id])
    end

    if params[:user_id]
      @user = User.find(params[:user_id])
    end

    if params[:game_id]
      @game = Game.find_by_id(params[:game_id])
    end

    if params[:character_id]
      @character = Character.find_by_id(params[:character_id])
    end

    if params[:publisher_id]
      @publisher= User.find(params[:publisher_id])
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @system_categories }
    end
  end

  # GET /system_categories/1
  # GET /system_categories/1.xml
  def show
    @system_category = SystemCategory.find(params[:id])
    @comments = @system_category.comments.find(:all, :limit => 10, :order => 'created_at ')
    
    @posts = @system_category.comments.find(:all, :limit => 10, :order => 'created_at')

    #@popular_posts = @category.posts.find(:all, :limit => 10, :order => "view_count DESC")
    #@popular_polls = Poll.find_popular_in_category(@category)
    #@rss_title = "#{configatron.community_name}: #{@category.name} "+:posts.l
    #@rss_url = category_path(@category, :format => :rss)    

    respond_to do |format|
      format.html { render :layout => 'application' }
      format.xml  { render :xml => @system_category }
    end
  end

  # GET /system_categories/new
  # GET /system_categories/new.xml
  def new
    @system_category = SystemCategory.new

    respond_to do |format|
      format.html { render :layout => 'application' }
      format.xml  { render :xml => @system_category }
    end
  end

  # GET /system_categories/1/edit
  def edit
    @system_category = SystemCategory.find(params[:id])
    render :layout => 'application'
  end

  # POST /ystem_categoriess
  # POST /system_categories.xml
  def create
    if !current_user
      flash[:error] = "You must be logged in to create a category"
      redirect_to home_url
    end

    @system_category = current_user.system_categories.new(params[:system_category])

    respond_to do |format|
      if @system_category.save
        flash[:notice] = 'Category was successfully created.'
        format.html { redirect_to @system_category }
        format.xml  { render :xml => @system_category, :status => :created, :location => @system_category }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @system_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /system_categories/1
  # PUT /system_categories/1.xml
  def update
    @system_category = SystemCategory.find(params[:id])
    if current_user.nil? || !(current_user == @system_category.owner || current_user.admin?)
      flash[:error] = 'You may not edit a system_category you do not own.'
      redirect_to system_category @system_category
      return
    end


    respond_to do |format|
      if @system_category.update_attributes(params[:system_category])

        # Causes slug to be regenerated
        @system_category.name_slug = ''
        @system_category.save!

        flash[:notice] = 'SystemCategory was successfully updated.'
        format.html { redirect_to(@system_category) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @system_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /system_categories/1
  # DELETE /system_categories/1.xml
  def destroy
    @system_category = SystemCategory.find(params[:id])

    if @system_category.user_id == current_user.id || current_user.admin?
      @system_category.destroy
      flash[:info] = "Category deleted."

      respond_to do |format|
        format.html { redirect_to system_categories_path }
        format.xml  { head :ok }
      end
    else
      flash[:error] = "You may not delete categories you do not own."
      redirect_to home_url
    end

  end

  def update_views
    if logged_in?
      @system_category = SystemCategory.find(params[:id])
      updated = update_view_count(@ystem_categorys)
      render :text => updated ? 'updated' : 'duplicate'
      return
    end

    # not really a dup, but this isn't displayed anyway
    render :text => 'duplicate'
  end  
    
  
  def change_profile_photo
    @system_category = SystemCategory.find(params[:id])

    # TODO make this a before_filter
    if current_user.nil? || !( current_user == @system_category.owner || current_user.admin?)
      flash[:error] = "You can not edit this system_category."
      redirect_to @system_category
      return
    end
    
    @photo  = Photo.find(params[:photo_id])
    @system_category.avatar = @photo
    
    if @system_category.save!
      flash[:notice] = 'Category was successfully updated.'
      redirect_to @system_category
    else
      format.html { render :action => "edit", :layout => 'application' }
    end
  end

  def pick_profile_photo
    @system_category = SystemCategory.find(params[:id])
    
    # TODO make this a before_filter
    if current_user.nil? || !(current_user == @system_category.owner || current_user.admin?)
      flash[:error] = "You can not edit this system_category."
      redirect_to  @system_category
      return
    end
    
    @user = @system_category.owner

    @photos = current_user.photos.recent.page(params[:page]).per(100)

    respond_to do |format|
      format.html { render :layout => 'application' }
    end
  end

  def remove_profile_photo
    @system_category = SystemCategory.find(params[:id])
    @system_category.avatar = nil
    @system_category.save!
    redirect_to(@system_category)
  end

  #def games
  #  @system_category = SystemCategory.find(params[:system_category])
  #  @comments = @system_category.comments.find(:all, :limit => 10, :order => 'created_at ')
  #end
  #
  #def characters
  #  @system_category = SystemCategory.find(params[:system_category])
  #  @comments = @system_category.comments.find(:all, :limit => 10, :order => 'created_at ')
  #end

  def update_views
    if logged_in?
      @system_category = SystemCategory.find(params[:id])
      updated = update_view_count(@system_category)
      render :text => updated ? 'updated' : 'duplicate'
      return
    end

    # not really a dup, but this isn't displayed anyway
    render :text => 'duplicate'
  end

  def product_search
    redirect_to :controller => "products", :action => "index", :system_category_id => params[:id]
  end

  def product_add
    @system_category = SystemCategory.find(params[:id])

    if current_user && ( @system_category.owner == current_user || current_user.admin? )
      product = Product.find(params[:product_id])
      if !@system_category.products.include?product
        @system_category.products << product
      end
      #@comments = @system_category.comments.order('created_at ASC').limit(200)
      redirect_to @system_category
    else
      flash[:error] = 'You may not edit categories you do not own.'
      redirect_to user_path(current_user)
    end
  end

  def product_remove
    @system_category = SystemCategory.find(params[:id])

    if current_user && ( @system_category.owner == current_user || current_user.admin? )
      product = Product.find(params[:product_id])
      @system_category.products.delete(product)
      #@comments = @system_category.comments.order('created_at ASC').limit(200)
      redirect_to @system_category
    else
      flash[:error] = 'You may not edit categories you do not own.'
      redirect_to user_path(current_user)
    end
  end

  def bump_views
    if current_user && current_user.admin?
      @system_category = SystemCategory.find(params[:id])
      @system_category.view_count += 10
      @system_category.save!
      flash[:info] = "Views bumped to #{@system_category.view_count}"
      redirect_to @system_category
    else
      flash[:error] = 'NOPE!'
      redirect_to user_path(current_user)
    end
  end
end
