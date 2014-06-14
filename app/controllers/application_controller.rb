class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :check_domain

  private

  def check_domain
    return if Rails.env != 'production'
    domain = request.original_url.split('/')[2]
    if domain != 'www.hellopitch.com'
      redirect_to 'http://www.hellopitch.com/'
    end
  end

end
