require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Account do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :aws_account_number => "value for aws_account_number",
      :aws_access_key => "value for aws_access_key",
      :aws_secret_access_key => "value for aws_secret_access_key",
      :aws_x_509_key => "value for aws_x_509_key",
      :aws_x_509_certificate => "value for aws_x_509_certificate"
    }
    @account = Account.new(@valid_attributes)
  end

  it "should create a new instance given valid attributes" do
    @account.save!
  end

  describe "associations" do
    it "should have many users" do
      # No options on this association but ActiveMatchers complain unless .with_options({:extend=>[]}) is added. - SMB 8/22/08
      Account.should have_many(:users).with_options({:extend=>[]})
    end

    it "should have many images" do
      # No options on this association but ActiveMatchers complain unless .with_options({:extend=>[]}) is added. - SMB 8/22/08
      Account.should have_many(:images).with_options({:extend=>[], :order=>"location"})
    end
  end

  describe "ec2 proxy" do
    before do
      @account = Account.new(@valid_attributes)
    end

    def get_account_ec2_proxy
      @account.ec2
    end

    it "should return an instance of EC2::Base" do
      get_account_ec2_proxy.class.should == EC2::Base
    end

    it "should use the aws_access_key" do
      @account.should_receive(:aws_access_key).and_return("xxx")
      get_account_ec2_proxy
    end

    it "should use the aws_secret_access_key" do
      @account.should_receive(:aws_secret_access_key).and_return("xxx")
      get_account_ec2_proxy
    end
  end
end
