class Account < ActiveRecord::Base
  has_many :users
  has_many :key_pairs, :order => 'name'
  has_many :images,    :order => 'location'

  # Common Vendor Owner IDs
  module Vendors
    Alestic    = '063491364108'
    Amazon     = 'amazon'
    RBuilder   = '099034111737'
    RedHat     = '432018295444'
    RightScale = '411009282317'
    Scalr      = '788921246207'
  end

  def sync_images_with_ec2
    EC2Sync::Image.new(self).sync!
  end

  def ec2
    @ec2 ||= EC2::Base.new(:access_key_id => aws_access_key, :secret_access_key => aws_secret_access_key)
  end
end
