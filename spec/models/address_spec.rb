require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Address do
  before(:each) do
    @valid_attributes = {
      :account_id => "1",
      :instance_id => "value for instance_id",
      :public_ip => "value for public_ip"
    }
  end

  it "should create a new instance given valid attributes" do
    Address.create!(@valid_attributes)
  end

  it "should belong to an account" do
    Address.should belong_to(:account)
  end
end
