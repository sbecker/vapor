class DashboardController < ApplicationController
  before_filter :login_required

  def index
    @ec2_stats = {
      :address_count        => current_account.addresses.count,
      :image_count          => current_account.images.count,
      :instance_count       => current_account.instances.count,
      :key_pair_count       => current_account.key_pairs.count,
      :security_group_count => current_account.security_groups.count
    }
  end

end
