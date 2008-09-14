class Account < ActiveRecord::Base
  has_many :users
  has_many :addresses,          :order => 'public_ip'
  has_many :availability_zones, :order => 'name'
  has_many :key_pairs,          :order => 'name'
  has_many :images,             :order => 'location'
  has_many :security_groups,    :order => 'name'

  # Common Vendor Owner IDs
  module Vendors
    Alestic    = '063491364108'
    Amazon     = 'amazon'
    RBuilder   = '099034111737'
    RedHat     = '432018295444'
    RightScale = '411009282317'
    Scalr      = '788921246207'
  end

  def sync_with_ec2
    sync_models = [
      EC2Sync::Address,
      EC2Sync::AvailabilityZone,
      EC2Sync::KeyPair,
      EC2Sync::Image,
      EC2Sync::SecurityGroup
    ]
    sync_models.each {|m| m.new(self).sync! }
  end

  def ec2
    @ec2 ||= RightAws::Ec2.new(aws_access_key, aws_secret_access_key)
  end
end
