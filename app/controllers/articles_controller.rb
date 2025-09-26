class ArticlesController < ApplicationController
  before_action :set_article, only: %i[ show edit update destroy publish unpublish ]
  before_action :require_admin, except: %i[ index show ]

  def index
    @articles = if current_user.admin?
      Article.all.page(params[:page])
    else
      Article.published.recent.page(params[:page])
    end
  end

  def show
    # Article is already loaded by before_action
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)

    if @article.save
      redirect_to @article, notice: "Article was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # Article is already loaded by before_action
  end

  def update
    if @article.update(article_params)
      redirect_to @article, notice: "Article was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @article.destroy
    redirect_to articles_url, notice: "Article was successfully deleted."
  end

  def publish
    @article.update(published: true, published_at: Time.current)
    redirect_to @article, notice: "Article was published."
  end

  def unpublish
    @article.update(published: false)
    redirect_to @article, notice: "Article was unpublished."
  end

  private

  def set_article
    @article = Article.friendly.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:title, :published, :published_at, :content, images: [])
  end
end
