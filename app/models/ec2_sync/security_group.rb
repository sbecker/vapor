class EC2Sync::SecurityGroup < EC2Sync::Base
  def get_locals
    @account.security_groups.all
  end

  def get_remotes
    @account.ec2.describe_security_groups
  end

  def new_local
    @account.security_groups.new
  end

  def is_equal?(local, remote)
    local.name == remote[:aws_group_name]
  end

  def update_from_remote(local, remote)
    local.name        = remote[:aws_group_name]
    local.description = remote[:aws_description]
    local.owner_id    = remote[:aws_owner]
    local.permissions = remote[:aws_perms]
  end

  def handle_missing(local)
    local.destroy
  end
end
