class ForumsController < BaseController
  require_from_ce('controllers/forums_controller')

  protected
    def find_or_initialize_forum
      @forum = params[:id] ? Forum.find_by_id(params[:id]) : Forum.new

      if @forum.nil?
        flash[:error] = 'No such forum.'
        redirect_to home_url
        return
      end
      
    end
end
