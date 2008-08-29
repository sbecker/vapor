class DashboardController < ApplicationController
  before_filter :login_required

  def index
    @ec2_stats = {:image_count => current_account.images.count}
  end

end
