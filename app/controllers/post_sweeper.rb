class PostSweeper < ActionController::Caching::Sweeper
  require_from_ce('controllers/post_sweeper')
  private
  def expire_cache_for(record)
    cache_key = 'views/#{request.host_with_port}/index'
    Rails.cache.delete(cache_key)
  end
end