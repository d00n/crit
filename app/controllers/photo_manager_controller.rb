class PhotoManagerController < BaseController
  require_from_ce('controllers/photo_manager_controller')

  def index
    @albums = current_user.albums.order('id DESC').page(params[:page_albums]).per(12)
    @photos_no_albums = current_user.photos.where('album_id IS NULL').order('id DESC').page(params[:page]).per(100)
  end
end