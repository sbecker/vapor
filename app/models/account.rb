class Account < ActiveRecord::Base
  has_many :users
  has_many :addresses,          :order => 'public_ip'
  has_many :availability_zones, :order => 'zone_name'
  has_many :key_pairs,          :order => 'aws_key_name'
  has_many :images,             :order => 'aws_location'
  has_many :security_groups,    :order => 'aws_group_name'

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
    EC2Sync.sync_account(self)
  end

  def ec2
    @ec2 ||= RightAws::Ec2.new(aws_access_key, aws_secret_access_key)
  end
end
