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
    # Have-many associations have {:extend=>[]} because ActiveMatchers rspec extension complains unless its added. - SMB 8/22/08
    it "should have many users" do
      Account.should have_many(:users).with_options({:extend=>[]})
    end

    it "should have many addresses" do
      Account.should have_many(:addresses).with_options({:extend=>[], :order=>"public_ip"})
    end

    it "should have many availability zones" do
      Account.should have_many(:availability_zones).with_options({:extend=>[], :order=>"name"})
    end

    it "should have many key pairs" do
      Account.should have_many(:key_pairs).with_options({:extend=>[], :order=>"name"})
    end

    it "should have many images" do
      Account.should have_many(:images).with_options({:extend=>[], :order=>"location"})
    end

    it "should have many security groups" do
      Account.should have_many(:security_groups).with_options({:extend=>[], :order=>"name"})
    end
  end

  describe "ec2 proxy" do
    before do
      @account = Account.new(@valid_attributes)
    end

    def get_account_ec2_proxy
      @account.ec2
    end

    it "should return an instance of RightAws::Ec2" do
      get_account_ec2_proxy.class.should == RightAws::Ec2
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

  describe "vendor owner id shortcuts" do
    it "should have 'Alestic'" do
      Account::Vendors::Alestic.should_not be_nil
    end

    it "should have 'Amazon'" do
      Account::Vendors::Amazon.should_not be_nil
    end

    it "should have 'RBuilder'" do
      Account::Vendors::RBuilder.should_not be_nil
    end

    it "should have 'RedHat'" do
      Account::Vendors::RedHat.should_not be_nil
    end

    it "should have 'RightScale'" do
      Account::Vendors::RightScale.should_not be_nil
    end

    it "should have 'Scalr'" do
      Account::Vendors::Scalr.should_not be_nil
    end
  end

  describe "sync with ec2" do
    before do
      EC2Sync::Address.stub!(:new).and_return(mock("EC2Sync::Address", :sync! => true))
      EC2Sync::AvailabilityZone.stub!(:new).and_return(mock("EC2Sync::AvailabilityZone", :sync! => true))
      EC2Sync::Image.stub!(:new).and_return(mock("EC2Sync::Image", :sync! => true))
      EC2Sync::KeyPair.stub!(:new).and_return(mock("EC2Sync::KeyPair", :sync! => true))
      EC2Sync::SecurityGroup.stub!(:new).and_return(mock("EC2Sync::SecurityGroup", :sync! => true))
    end

    it "should sync addresses" do
      ec2sync_address = mock_model(EC2Sync::Address)
      EC2Sync::Address.should_receive(:new).with(@account).and_return(ec2sync_address)
      ec2sync_address.should_receive(:sync!)
    end

    it "should sync images" do
      ec2sync_availability_zone = mock_model(EC2Sync::AvailabilityZone)
      EC2Sync::AvailabilityZone.should_receive(:new).with(@account).and_return(ec2sync_availability_zone)
      ec2sync_availability_zone.should_receive(:sync!)
    end

    it "should sync images" do
      ec2sync_image = mock_model(EC2Sync::Image)
      EC2Sync::Image.should_receive(:new).with(@account).and_return(ec2sync_image)
      ec2sync_image.should_receive(:sync!)
    end

    it "should sync key pairs" do
      ec2sync_key_pair = mock_model(EC2Sync::KeyPair)
      EC2Sync::KeyPair.should_receive(:new).with(@account).and_return(ec2sync_key_pair)
      ec2sync_key_pair.should_receive(:sync!)
    end

    it "should security groups" do
      ec2sync_security_group = mock_model(EC2Sync::SecurityGroup)
      EC2Sync::SecurityGroup.should_receive(:new).with(@account).and_return(ec2sync_security_group)
      ec2sync_security_group.should_receive(:sync!)
    end

    after do
      @account.sync_with_ec2
    end
  end
end
