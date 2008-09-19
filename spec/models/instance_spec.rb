require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Instance do
  before(:each) do
    @valid_attributes = {
      :account_id => "1",
      :ami_launch_index => "1",
      :aws_availability_zone => "value for aws_availability_zone",
      :aws_groups => "value for aws_groups",
      :aws_image_id => "value for aws_image_id",
      :aws_instance_id => "value for aws_instance_id",
      :aws_instance_type => "value for aws_instance_type",
      :aws_kernel_id => "value for aws_kernel_id",
      :aws_launch_time => Time.now,
      :aws_owner => "value for aws_owner",
      :aws_product_codes => "value for aws_product_codes",
      :aws_ramdisk_id => "value for aws_ramdisk_id",
      :aws_reason => "value for aws_reason",
      :aws_reservation_id => "value for aws_reservation_id",
      :aws_state => "value for aws_state",
      :aws_state_code => "value for aws_state_code",
      :dns_name => "value for dns_name",
      :private_dns_name => "value for private_dns_name",
      :ssh_key_name => "value for ssh_key_name"
    }
  end

  it "should create a new instance given valid attributes" do
    Instance.create!(@valid_attributes)
  end

  describe "associations" do
    it "should belong to an account" do
      Instance.should belong_to(:account)
    end
  end

end
