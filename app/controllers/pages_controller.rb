class PagesController < BaseController

  def show
    @page = Page.live.find(params[:id])
    
    if current_user
      @games_starting_soon = current_user.games_starting_soon
    end
    @sample_game = Game.find(19)
    @site_tour_post = Post.find(423)
    @game_table_tour_post = Post.find(532)

    @popular_tags = popular_tags(30).to_a
    @active_users = User.active.find_by_activity({:limit => 5, :require_avatar => false})
    @featured_writers = User.find_featured
    
    unless logged_in? || @page.page_public
      flash[:error] = :page_not_public_warning.l
      redirect_to :controller => 'sessions', :action => 'new'      
    end
  rescue
    flash[:error] = :page_not_found.l
    redirect_to home_path
  end


end
