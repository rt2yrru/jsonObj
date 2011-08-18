class ArticleSweeper < ActionController::Caching::Sweeper
  
  observe Article
  
  def after_create(article)
    expire_stale_pages
  end
  
  def after_update(article)
    expire_stale_pages
  end
  
  private
  
  def expire_stale_pages
    expire_fragment(:controller => 'articles', :action => 'index', :action_suffix => 'featured')
    expire_page articles_path
    expire_page load_more_articles_path(:format => :js)
    expire_action(:controller => 'articles', :action => :paginated, :cache_path => Proc.new { |c| c.params })
  end
  
end