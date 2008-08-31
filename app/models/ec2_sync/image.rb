class EC2Sync::Image < EC2Sync::Base
  def get_locals
    ::Image.available.all(:conditions => ["is_public = ? OR account_id = ?", true, @account.id])
  end

  def get_remotes
    @account.ec2.describe_images
  end

  def new_local
    ::Image.new
  end

  def is_equal?(local, remote)
    local.aws_id == remote[:aws_id]
  end

  def get_account_ids_from_owner_ids
    all_accounts = Account.all(:select => "aws_account_number, id")
    Hash[*(all_accounts.map{|a| [a.aws_account_number, a.id] }.flatten)]
  end

  def account_ids_from_owner_ids
    @account_ids_from_owner_ids ||= get_account_ids_from_owner_ids
  end

  def update_from_remote(local, remote)
    local.account_id   = account_ids_from_owner_ids[remote[:aws_owner]]
    local.architecture = remote[:aws_architecture]
    local.aws_id       = remote[:aws_id]
    local.is_public    = remote[:aws_is_public]
    local.location     = remote[:aws_location]
    local.owner_id     = remote[:aws_owner]
    local.state        = remote[:aws_state]
    local.image_type   = remote[:aws_image_type]
  end

  def handle_missing(local)
    local.update_attribute(:state, "deregistered")
  end
end
