class ApplicationQuery
  def initialize(scope, query_params)
    @scope = scope
    @query_params = query_params
  end

  def call
    @query_params.each do |key, value|
      @scope = send("filter_by_#{key}", value)
    end

    @scope.page(@query_params[:page])
  end
end
