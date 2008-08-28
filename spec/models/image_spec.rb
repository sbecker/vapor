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
      :image_type => "value for image_type"
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
        " AND owner_id != '#{Account::Vendors::Alestic}'" +
        " AND owner_id != '#{Account::Vendors::Amazon}'" +
        " AND owner_id != '#{Account::Vendors::RBuilder}'" +
        " AND owner_id != '#{Account::Vendors::RedHat}'" +
        " AND owner_id != '#{Account::Vendors::RightScale}'" +
        " AND owner_id != '#{Account::Vendors::Scalr}'"
      )
      Image.others(account_id)
    end
  end
end
