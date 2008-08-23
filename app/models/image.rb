class Image < ActiveRecord::Base
  # would just use "public" but this causes weird nil.call errors in rspec - SMB 8/22/08
  # see http://www.nabble.com/Mysterious-interaction-between-RSpec-1.1.4-and-has_finder-named_scope-tt17810058.html#a17810058
  named_scope :all_public,  :conditions => {:is_public => true}
  named_scope :all_private, :conditions => {:is_public => false}
  named_scope :available,   :conditions => {:state     => 'available'}

  attr_accessible :name, :description

  class << self
    def sync_ec2_for_account(account)
      ec2_images = account.ec2.describe_images.imagesSet.item
      existing_images = account.images

      ec2_images.each do |ec2_image|
        existing_image = existing_images.detect{|i| i.aws_id == ec2_image.imageId }
        if existing_image
          update_from_ec2(existing_image, ec2_image)
        else
          create_from_ec2(account.images.new, ec2_image)
        end
      end

      # mark any existing images missing from ec2 as deregisterd
      missing_images = existing_images.reject {|i| ec2_images.detect{|e| i.aws_id == e.imageId } }
      missing_images.each do |missing_image|
        missing_image.update_attribute(:state, "deregistered")
      end
    end

    def update_from_ec2(image, ec2_image)
      image.is_public = ec2_image.isPublic == "true"
      image.state     = ec2_image.imageState
      image.save
    end

    def create_from_ec2(image, ec2_image)
      image.architecture = ec2_image.architecture
      image.aws_id       = ec2_image.imageId
      image.is_public    = ec2_image.isPublic == "true"
      image.location     = ec2_image.imageLocation
      image.owner_id     = ec2_image.imageOwnerId
      image.state        = ec2_image.imageState
      image.image_type   = ec2_image.imageType

      image.save
    end
  end
end
