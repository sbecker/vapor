class EC2Sync::Address < EC2Sync::Base
  def get_locals
    @account.addresses.all
  end

  def get_remotes
    @account.ec2.describe_addresses
  end

  def new_local
    @account.addresses.new
  end

  def is_equal?(local, remote)
    local.public_ip == remote[:public_ip]
  end

  def update_from_remote(local, remote)
    local.instance_id = remote[:instance_id]
    local.public_ip   = remote[:public_ip]
  end

  def handle_missing(local)
    local.destroy
  end
end
