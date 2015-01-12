class EventSweeper < ActionController::Caching::Sweeper
  observe Event

  def after_create(event)
    expire_cache_for(event)
  end
  
  def after_update(event)
    expire_cache_for(event)
  end
  
  def after_destroy(event)
    expire_cache_for(event)
  end
          
  private
  def expire_cache_for(record)
    # Expire the home page
    expire_action(:controller => 'base', :action => 'site_index')

    # Expire the footer content
    expire_action(:controller => 'base', :action => 'footer_content')
    
    # Also expire the sitemap
    expire_action(:controller => 'sitemap', :action => 'index')

  end
end
