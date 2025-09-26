class HomeController < ApplicationController
  def index
    @recent_articles = Article.published.recent.limit(3)
    @total_articles = Article.published.count
  end
end
