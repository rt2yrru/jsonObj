class ArticlesController < ApplicationController
  
  before_filter :authenticate, :only => [:new, :create, :edit, :update]
  caches_page :index, :load_more
  
  def index
    @articles = Article.limit(1)
  end

  def load_more
    @articles = Article.all
    render :json => @articles
  end

  def show
    @article = Article.find(params[:id])
  end

  def new
    @article = Article.new
  end

  def edit
    @article = Article.find(params[:id])
  end

  def create
    @article = Article.new(params[:article])
    if @article.save
      expire_stale_pages
      expire_fragment(:action => 'index', :action_suffix => 'featured')
      redirect_to(@article, :notice => 'Article was successfully created.')
    else
      render :action => "new"
    end
  end

  def update
    @article = Article.find(params[:id])
    if @article.update_attributes(params[:article])
      expire_stale_pages
      redirect_to(@article, :notice => 'Article was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy
    redirect_to(articles_url)
  end
  
  def temp_authenticate
    session[:authenticated] = true
    expire_page articles_path
    expire_fragment(:action => 'index', :action_suffix => 'authenticate')
    redirect_to(articles_path)
  end
  
  def temp_unauthenticate
    session[:authenticated] = false
    expire_page articles_path
    expire_fragment(:action => 'index', :action_suffix => 'authenticate')
    redirect_to(articles_path)
  end
  
  private
  
  def expire_stale_pages
    expire_page articles_path
    expire_page load_more_articles_path(:format => :js)
  end
  
  def authenticate
    redirect_to(articles_path, :notice => 'Unauthenticated!') unless session[:authenticated] == true
  end
  
end