class ArticlesController < ApplicationController
  before_action :set_article, only: %i[ show edit update destroy publish unpublish remove_image ]
  before_action :require_admin, except: %i[ index show ]

  def index
    @articles = query(scope)
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
    # Handle images separately to prevent deletion of existing images
    update_params = article_params.except(:images)

    if @article.update(update_params)
      # Only attach new images if they were actually selected
      if params[:article][:images].present? && params[:article][:images].any?(&:present?)
        @article.images.attach(params[:article][:images])
      end

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

  def remove_image
    image = @article.images.find(params[:image_id])
    image.purge
    redirect_to edit_article_path(@article), notice: "Image was removed."
  rescue ActiveRecord::RecordNotFound
    redirect_to edit_article_path(@article), alert: "Image not found."
  end


  private

  def set_article
    @article = Article.friendly.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:title, :published, :published_at, :content, :tag_list, images: [])
  end

  def scope
    if admin?
      Article.includes(:tags)
    else
      Article.published.recent.includes(:tags)
    end
  end
end
