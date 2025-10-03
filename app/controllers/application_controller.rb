class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  helper_method :current_user, :logged_in?, :admin?

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def admin?
    current_user&.admin?
  end

  def require_login
    unless logged_in?
      flash[:alert] = "You must be logged in to access this page"
      redirect_to login_path
    end
  end

  def require_admin
    unless admin?
      flash[:alert] = "You must be an admin to access this page"
      redirect_to root_path
    end
  end

  def query(scope)
    query_class = "#{controller_name.camelize}Query"
    query_class.constantize.new(
      scope,
      request.query_parameters
    ).call
  end
end
