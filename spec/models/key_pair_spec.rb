require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe KeyPair do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :fingerprint => "value for fingerprint",
      :private_key => "value for private_key",
      :account_id => "1",
      :user_id => "1"
    }
  end

  it "should create a new instance given valid attributes" do
    KeyPair.create!(@valid_attributes)
  end
  
  describe "associations" do
    it "should belong to an account" do
      # No options on this association but ActiveMatchers complain unless .with_options({:extend=>[]}) is added. - SMB 8/22/08
      KeyPair.should belong_to(:account)
    end
  end

  describe "accessible attributes" do
    before do
      @key_pair = KeyPair.new(@valid_attributes)
    end

    it "should include 'name'" do
      @key_pair.name.should == @valid_attributes[:name]
    end

    it "should not include any other attributes" do
      inaccessible_attributes = @valid_attributes
      inaccessible_attributes.delete(:name)

      inaccessible_attributes.each_key do |key|
        @key_pair.send(key).should be_nil
      end
    end
  end

end
