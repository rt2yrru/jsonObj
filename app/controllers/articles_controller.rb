class ArticlesController < ApplicationController
  
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
  
  private
  
  def expire_stale_pages
    expire_page articles_path
    expire_page load_more_articles_path(:format => :js)
  end
  
end