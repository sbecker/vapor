require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SecurityGroup do
  before(:each) do
    @valid_attributes = {
      :account_id => "1",
      :name => "value for name",
      :description => "value for description",
      :owner_id => "value for owner_id",
      :permissions => "value for permissions"
    }
  end

  it "should create a new instance given valid attributes" do
    SecurityGroup.create!(@valid_attributes)
  end

  it "should belong to an account" do
    SecurityGroup.should belong_to(:account)
  end
end
