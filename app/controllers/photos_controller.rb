class PhotosController < BaseController
  require_from_ce('controllers/photos_controller')


  ## GET /photos
  ## GET /photos.xml
  #def index
  #  @user = User.find(params[:user_id])
  #
  #  if current_user && current_user == @user
  #    @photos = @user.photos.recent.page(params[:page]).per(100)
  #  else
  #    @photos = @user.photos.where(:is_private => false).recent.page(params[:page]).per(100)
  #  end
  #
  #
  #  #@tags = Photo.tag_counts :conditions => { :user_id => @user.id }, :limit => 20
  #
  #  @rss_title = "#{configatron.community_name}: #{@user.login}'s photos"
  #  @rss_url = user_photos_path(@user,:format => :rss)
  #
  #  respond_to do |format|
  #    format.html # index.rhtml
  #    format.rss {
  #      render_rss_feed_for(@photos,
  #         { :feed => {:title => @rss_title, :link => url_for(:controller => 'photos', :action => 'index', :user_id => @user) },
  #           :item => {:title => :name,
  #                     :description => Proc.new {|photo| description_for_rss(photo)},
  #                     :link => Proc.new {|photo| user_photo_url(photo.user, photo)},
  #                     :pub_date => :created_at} })
  #
  #    }
  #    format.xml { render :action => 'index.rxml', :layout => false}
  #  end
  #end

  # GET /photos/new
  def new
    @user = User.find(params[:user_id])
    @photo = Photo.new

    if  defined?params[:game_id]
      @game_id = params[:game_id]
    end

    if  defined?params[:character_id]
      @character_id = params[:character_id]
    end

    if params[:album_id]
      @album = Album.find(params[:album_id])
    end
    
    if params[:inline]
      render :action => 'inline_new', :layout => false
    end

  end

  # GET /photos/1;edit
  def edit
    @photo = Photo.find(params[:id])
    @user = @photo.user

    if params[:album_id]
      @album = Album.find(params[:album_id])
    end

  end

  # POST /photos
  # POST /photos.xml
  def create
    @user = current_user
    @photo = Photo.new(params[:photo])
    @photo.user = @user
    @photo.tag_list = params[:tag_list] || ''

    @photo.album_id = params[:album_id] || ''
    @photo.album_id = params[:album_selected] unless params[:album_selected].blank?

    respond_to do |format|
      if @photo.save

        if params[:game_id]
          @game = Game.find(params[:game_id])
          @game.avatar = @photo
          @game.save

          @photo.is_private = @game.is_private
          @photo.save

          redirect_to seo_game_path(@game)
          return
        end

        if params[:character_id]
          @character = Character.find(params[:character_id])
          @character.avatar = @photo
          @character.save

          @photo.is_private = @character.is_private
          @photo.save

          redirect_to seo_character_path(@character)
          return
        end

        
        #start the garbage collector
#        GC.start
        flash[:notice] = :photo_was_successfully_created.l

        format.html {
          render :action => 'inline_new', :layout => false and return if params[:inline]
          if params[:album_id]
            redirect_to user_album_path(current_user,params[:album_id])
          else
            redirect_to user_photo_url(:id => @photo, :user_id => @photo.user)
          end
        }
        format.js {
          responds_to_parent do
            render :update do |page|
              page << "upload_image_callback('#{@photo.photo.url}', '#{@photo.display_name}', '#{@photo.id}');"
            end
          end
        }
      else
        format.html {
          flash[:notice] = "Photo did not save. Was it over 3 megabytes in size?"
          redirect_to :controller => 'characters', :action => 'new_avatar_photo', :id => params[:character_id], :layout => false and return if params[:character_id]
          redirect_to :controller => 'games', :action => 'new_avatar_photo', :id => params[:game_id], :layout => false and return if params[:game_id]
          render :action => 'inline_new', :layout => false and return if params[:inline]
          render :action => "new"
        }
        format.js {
          responds_to_parent do
            render :update do |page|
              page.alert(:sorry_there_was_an_error_uploading_the_photo.l)
            end
          end
        }
      end
    end
  end

  def show
    begin
      @photo = @user.photos.find(params[:id])
    rescue
      flash[:error] = "Photo not found"
      redirect_to user_photos_path(@user)
      return
    end
    
    if @photo.is_private && (current_user.nil? || current_user != @photo.user)
      flash[:error] = "Photo is private"
      redirect_to user_path(@photo.user)
      return
    end
    
    update_view_count(@photo) if current_user && current_user.id != @photo.user_id

    @is_current_user = @user.eql?(current_user)
    @comment = Comment.new(params[:comment])

    @previous = @photo.previous_photo
    @next = @photo.next_photo
    @related = Photo.find_related_to(@photo)

    respond_to do |format|
      format.html # show.rhtml
    end
  end

# DELETE /photos/1
  # DELETE /photos/1.xml
  def destroy
    @user = User.find(params[:user_id])
    @photo = Photo.find(params[:id])
    if @user.avatar.eql?(@photo)
      @user.avatar = nil
      @user.save!
    end
    @user.games.each do |game|
      if game.avatar.eql?(@photo)
        game.avatar = nil
        game.save!
      end
    end
    @user.characters.each do |character|
      if character.avatar.eql?(@photo)
        character.avatar = nil
        character.save!
      end
    end
    @photo.destroy

    respond_to do |format|
      format.html { redirect_to user_photos_url(@photo.user)   }
    end
  end

  protected
  def photo_params
    params[:photo].permit(:name, :description, :album_id, :photo, :is_private)
  end
end
