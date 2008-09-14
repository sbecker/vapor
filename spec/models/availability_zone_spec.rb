require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AvailabilityZone do
  before(:each) do
    @valid_attributes = {
      :account_id => "1",
      :name => "value for name",
      :state => "value for state"
    }
  end

  it "should create a new instance given valid attributes" do
    AvailabilityZone.create!(@valid_attributes)
  end

  it "should belong to an account" do
    AvailabilityZone.should belong_to(:account)
  end
end
