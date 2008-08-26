class DashboardController < ApplicationController
  before_filter :login_required

  def index
    @ec2_stats = {:image_count => current_user.images.count}
  end

end
