class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user

  def current_user
    return nil if not session[:url]
    User.find_by_public_url(session[:url])
  end

  def must_have_user
    redirect_to root_path if not current_user
  end

end
