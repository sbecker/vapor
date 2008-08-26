class EC2Sync::Image
  def initialize(account)
    @account = account
  end

  def sync!
    create_and_update_listed
    deregister_unlisted
  end

  def ec2_images
    @ec2_images ||= @account.ec2.describe_images.imagesSet.item
  end

  def local_images
    @local_images ||= @account.images
  end

  def create_and_update_listed
    ec2_images.each do |ec2_image|
      local_image = local_images.detect{|i| i.aws_id == ec2_image.imageId } || Image.new
      update_from_ec2(local_image, ec2_image)
    end
  end

  def deregister_unlisted
    missing_images = local_images.reject {|i| ec2_images.detect{|e| i.aws_id == e.imageId } }
    missing_images.each do |missing_image|
      missing_image.update_attribute(:state, "deregistered")
    end
  end

  def update_from_ec2(local_image, ec2_image)
    local_image.account_id   = ec2_image.imageOwnerId == @account.aws_account_number ? @account.id : nil
    local_image.architecture = ec2_image.architecture
    local_image.aws_id       = ec2_image.imageId
    local_image.is_public    = ec2_image.isPublic == "true"
    local_image.location     = ec2_image.imageLocation
    local_image.owner_id     = ec2_image.imageOwnerId
    local_image.state        = ec2_image.imageState
    local_image.image_type   = ec2_image.imageType

    local_image.save
  end
end
