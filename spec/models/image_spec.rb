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

end
