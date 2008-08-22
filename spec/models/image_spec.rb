require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Image do
  before(:each) do
    @valid_attributes = {
      :architecture => "value for architecture",
      :aws_id => "value for aws_id",
      :description => "value for description",
      :is_public => false,
      :location => "value for location",
      :name => "value for name",
      :owner_id => "value for owner_id",
      :state => "value for state",
      :type => "value for type"
    }
  end

  it "should create a new instance given valid attributes" do
    Image.create!(@valid_attributes)
  end
end
