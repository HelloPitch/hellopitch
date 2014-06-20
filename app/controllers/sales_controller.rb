class SalesController < ApplicationController

  before_action :must_have_user
  before_action :active_tab

  def index
  end

  def targets
  end

  def history
  end

  def profile
  end

  def payment
  end

  private

  def active_tab
    path = request.env['PATH_INFO']
    @active = 'targets' if path.index('/targets')
    @active = 'history' if path.index('/history')
    @active = 'profile' if path.index('/profile')
    @active = 'payment' if path.index('/payment')
  end

end
