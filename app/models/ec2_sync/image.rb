class EC2Sync::Image < EC2Sync::Base
  def get_locals
    ::Image.available.all(:conditions => ["is_public = ? OR account_id = ?", true, @account.id])
  end

  def get_remotes
    @account.ec2.describe_images.imagesSet.item
  end

  def new_local
    ::Image.new
  end

  def is_equal?(local, remote)
    local.aws_id == remote.imageId
  end

  def get_account_ids_from_owner_ids
    all_accounts = Account.all(:select => "aws_account_number, id")
    Hash[*(all_accounts.map{|a| [a.aws_account_number, a.id] }.flatten)]
  end

  def account_ids_from_owner_ids
    @account_ids_from_owner_ids ||= get_account_ids_from_owner_ids
  end

  def update_from_remote(local, remote)
    local.account_id   = account_ids_from_owner_ids[remote.imageOwnerId]
    local.architecture = remote.architecture
    local.aws_id       = remote.imageId
    local.is_public    = remote.isPublic == "true"
    local.location     = remote.imageLocation
    local.owner_id     = remote.imageOwnerId
    local.state        = remote.imageState
    local.image_type   = remote.imageType
  end

  def handle_missing(local)
    local.update_attribute(:state, "deregistered")
  end
end
