class ArticlesQuery < ApplicationQuery
  def filter_by_tag(tag)
    @scope.includes(:tags).where(tags: { name: tag })
  end
end
