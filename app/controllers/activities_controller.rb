class ActivitiesController < BaseController
  require_from_ce('controllers/activities_controller')

  def network
    @activities = @user.network_activity(:per_page => 15, :page => params[:page])
    get_additional_data
  end

  def index
    @activities = User.recent_activity.page(params[:page]).per(100)
    get_additional_data
  end

  def get_additional_data
    if current_user
      @games_starting_soon = current_user.games_starting_soon
    end
    @sample_game = Game.find(19)
    @site_tour_post = Post.find(423)
    @game_table_tour_post = Post.find(532)


    @popular_tags = popular_tags(30).to_a
    @active_users = User.active.find_by_activity({:limit => 5, :require_avatar => false})
    @featured_writers = User.find_featured
  end

end
