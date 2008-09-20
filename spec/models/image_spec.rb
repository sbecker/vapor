require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Image do
  before(:each) do
    @valid_attributes = {
      :aws_architecture => "value for aws_architecture",
      :aws_id           => "value for aws_id",
      :aws_is_public    => false,
      :aws_location     => "value for aws_location",
      :aws_owner        => "value for aws_owner",
      :aws_state        => "value for aws_state",
      :aws_image_type   => "value for aws_image_type",
      :description      => "value for description",
      :name             => "value for name"
    }
  end

  it "should create a new instance given valid attributes" do
    Image.create!(@valid_attributes)
  end

  describe "associations" do
    it "should belong to an account" do
      Image.should belong_to(:account)
    end
  end

  describe "named scopes" do
    # Want a better way to test this.
    it "should have an are_public named scope" do
      Image.singleton_methods.should include("are_public")
    end

    it "should have an not_public named scope" do
      Image.singleton_methods.should include("not_public")
    end

    it "should have an available named scope" do
      Image.singleton_methods.should include("available")
    end
  end

  describe "accessible attributes" do
    before do
      @image = Image.new(@valid_attributes)
      @accessible_attributes = %w( name description ).map{|a| a.to_sym }
      @inaccessible_attributes = @valid_attributes.keys - @accessible_attributes
    end

    it "should set accessible attributes - name and description" do
      @accessible_attributes.each do |attr|
        @image.send(attr).should == @valid_attributes[attr]
      end
    end

    it "should not set any other attributes" do
      @inaccessible_attributes.each do |attr|
        @image.send(attr).should be_nil
      end
    end
  end

  describe "others" do
    it "should find images that are not in the standard vendor list and don't belong to the current user's account" do
      account_id = 1
      Image.should_receive(:all).with(:conditions => "(account_id != #{account_id} OR account_id IS NULL)" +
        " AND aws_owner != '#{Account::Vendors::Alestic}'" +
        " AND aws_owner != '#{Account::Vendors::Amazon}'" +
        " AND aws_owner != '#{Account::Vendors::RBuilder}'" +
        " AND aws_owner != '#{Account::Vendors::RedHat}'" +
        " AND aws_owner != '#{Account::Vendors::RightScale}'" +
        " AND aws_owner != '#{Account::Vendors::Scalr}'"
      )
      Image.others(account_id)
    end
  end

  describe "setting aws_owner" do
    before do
      @image = Image.new
    end

    it "should also set the account id" do
      @image.should_receive(:account_id=)
    end

    it "should query the Account model for the account id from the supplied aws_owner string" do
      Account.should_receive(:ids_from_account_numbers).and_return({})
    end

    it "should set the account id to a value if the aws owner matches a key in the hash" do
      Account.stub!(:ids_from_account_numbers).and_return({'foo' => 25})
      @image.should_receive(:account_id=).with(25)
    end

    it "should set the account id to nil if the aws owner does not matche a key in the hash" do
      Account.stub!(:ids_from_account_numbers).and_return({'bar' => 25})
      @image.should_receive(:account_id=).with(nil)
    end

    after do
      @image.aws_owner = "foo"
    end
  end
end
