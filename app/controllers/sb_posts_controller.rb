class SbPostsController < BaseController
  require_from_ce('controllers/sb_posts_controller')

  def index

    respond_to do |format|
      format.rss {
        render :nothing => true
        return
      }
    end

    conditions = []
    [:user_id, :forum_id].each { |attr|
      conditions << SbPost.send(:sanitize_sql, ["sb_posts.#{attr} = ?", params[attr].to_i]) if params[attr]
    }
    conditions = conditions.any? ? conditions.collect { |c| "(#{c})" }.join(' AND ') : nil

    @posts = SbPost.with_query_options.where(conditions).page(params[:page])

    @users = User.distinct.where(:id => @posts.collect(&:user_id).uniq).to_a.index_by(&:id)
  end

  protected
    #overide in your app
    def authorized?
      # I added edit, update, index and destroy, because recent, rss, edit, and deltee were bombing
      # No idea what sort of security issue that may be
      %w(create new edit update index destroy).include?(action_name) || @post.editable_by?(current_user)
    end
    
end
