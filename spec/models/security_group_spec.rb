require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SecurityGroup do
  before(:each) do
    @valid_attributes = {
      :account_id      => "1",
      :aws_group_name  => "value for aws_group_name",
      :aws_description => "value for aws_description",
      :aws_owner       => "value for aws_owner",
      :aws_perms       => "value for aws_perms"
    }
  end

  it "should create a new instance given valid attributes" do
    SecurityGroup.create!(@valid_attributes)
  end

  describe "associations" do

    it "should belong to an account" do
      SecurityGroup.should belong_to(:account)
    end

  end

  describe "named scopes" do

    it "should have a 'for_select' named scope which only returns the 'aws_group_name'" do
      SecurityGroup.should have_named_scope(:for_select, :select => 'aws_group_name')
    end

  end

end
