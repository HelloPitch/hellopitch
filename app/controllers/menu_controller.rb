class MenuController < ApplicationController

  before_action :must_have_user

  def index
  end

  private

  def must_have_user
    redirect_to root_path if not current_user
  end

end
