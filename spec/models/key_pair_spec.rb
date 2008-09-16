require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe KeyPair do
  before(:each) do
    @valid_attributes = {
      :aws_key_name    => "value for aws_key_name",
      :aws_fingerprint => "value for aws_fingerprint",
      :aws_material    => "value for aws_material",
      :account_id      => "1",
      :user_id         => "1"
    }
  end

  it "should create a new instance given valid attributes" do
    KeyPair.create!(@valid_attributes)
  end
  
  describe "associations" do
    it "should belong to an account" do
      KeyPair.should belong_to(:account)
    end
  end

  describe "accessible attributes" do
    before do
      @key_pair = KeyPair.new(@valid_attributes)
    end

    it "should include 'aws_key_name'" do
      @key_pair.aws_key_name.should == @valid_attributes[:aws_key_name]
    end

    it "should not include any other attributes" do
      inaccessible_attributes = @valid_attributes
      inaccessible_attributes.delete(:aws_key_name)

      inaccessible_attributes.each_key do |key|
        @key_pair.send(key).should be_nil
      end
    end
  end

end
