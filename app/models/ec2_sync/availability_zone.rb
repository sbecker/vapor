class EC2Sync::AvailabilityZone < EC2Sync::Base
  def get_locals
    @account.availability_zones.all
  end

  def get_remotes
    @account.ec2.describe_availability_zones
  end

  def new_local
    @account.availability_zones.new
  end

  def is_equal?(local, remote)
    local.name == remote[:zone_name]
  end

  def update_from_remote(local, remote)
    local.name  = remote[:zone_name]
    local.state = remote[:zone_state]
  end

  def handle_missing(local)
    local.destroy
  end
end
