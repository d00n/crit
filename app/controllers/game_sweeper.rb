class GameSweeper < ActionController::Caching::Sweeper
  observe Game

  def after_create(game)
    expire_cache_for(game)
  end
  
  def after_update(game)
    expire_cache_for(game)
  end
  
  def after_destroy(game)
    expire_cache_for(game)
  end
          
  private
  def expire_cache_for(record)
    # not caching index yet
    #expire_action(:controller => 'game', :action => 'index')

    record.tags.each do |tag|
      expire_action(tag_url(tag))
    end
  end
end
