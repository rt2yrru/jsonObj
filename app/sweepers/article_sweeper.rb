class ArticleSweeper < ActionController::Caching::Sweeper
  
  observe Article
  
  def after_create(article)
    expire_stale_pages
    expire_fragment(:controller => 'articles', :action => 'index', :action_suffix => 'featured')
  end
  
  def after_update(article)
    expire_stale_pages
  end
  
  private
  
  def expire_stale_pages
    expire_page articles_path
    expire_page load_more_articles_path(:format => :js)
  end
  
end