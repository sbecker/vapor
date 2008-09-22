require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AvailabilityZone do
  before(:each) do
    @valid_attributes = {
      :account_id => "1",
      :zone_name  => "value for zone_name",
      :zone_state => "value for zone_state"
    }
  end

  it "should create a new instance given valid attributes" do
    AvailabilityZone.create!(@valid_attributes)
  end

  describe "associations" do

    it "should belong to an account" do
      AvailabilityZone.should belong_to(:account)
    end

  end

  describe "named scopes" do

    it "should have an 'available' named scope where 'zone_state' is 'available'" do
      AvailabilityZone.should have_named_scope(:available, :conditions => {:zone_state => 'available'})
    end

    it "should have a 'for_select' named scope which only returns the 'zone_name'" do
      AvailabilityZone.should have_named_scope(:for_select, :select => 'zone_name')
    end

  end

end
