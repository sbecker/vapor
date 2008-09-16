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
    end

    it "should include 'name'" do
      @image.name.should == @valid_attributes[:name]
    end

    it "should include 'description'" do
      @image.description.should == @valid_attributes[:description]
    end

    it "should not include any other attributes" do
      inaccessible_attributes = @valid_attributes
      inaccessible_attributes.delete(:name)
      inaccessible_attributes.delete(:description)

      inaccessible_attributes.each_key do |key|
        @image.send(key).should be_nil
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
end
