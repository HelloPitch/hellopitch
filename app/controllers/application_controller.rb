class ApplicationController < ActionController::Base
  helper_method :current_user

  def current_user
    return nil if not session[:url]
    User.find_by_public_url(session[:url])
  end

  def must_have_user
    redirect_to root_path if not current_user
  end

end
