class EC2Sync::KeyPair < EC2Sync::Base
  def get_locals
    @account.key_pairs.all
  end

  def get_remotes
    @account.ec2.describe_keypairs
  end

  def new_local
    @account.key_pairs.new
  end

  def is_equal?(local, remote)
    local.name == remote[:aws_key_name] && local.fingerprint == remote[:aws_fingerprint]
  end

  def update_from_remote(local, remote)
    local.name        = remote[:aws_key_name]
    local.fingerprint = remote[:aws_fingerprint]
  end

  def handle_missing(local)
    local.destroy
  end
end
