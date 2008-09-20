require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Account do
  before(:each) do
    @valid_attributes = {
      :name                  => "value for name",
      :aws_account_number    => "value for aws_account_number",
      :aws_access_key        => "value for aws_access_key",
      :aws_secret_access_key => "value for aws_secret_access_key",
      :aws_x_509_key         => "value for aws_x_509_key",
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
      Account.should have_many(:availability_zones).with_options({:extend=>[], :order=>"zone_name"})
    end

    it "should have many key pairs" do
      Account.should have_many(:key_pairs).with_options({:extend=>[], :order=>"aws_key_name"})
    end

    it "should have many images" do
      Account.should have_many(:images).with_options({:extend=>[], :order=>"aws_location"})
    end

    it "should have many instances" do
      Account.should have_many(:instances).with_options({:extend=>[]})
    end

    it "should have many security groups" do
      Account.should have_many(:security_groups).with_options({:extend=>[], :order=>"aws_group_name"})
    end

    it "should have many snapshots" do
      Account.should have_many(:snapshots).with_options({:extend=>[], :order=>"aws_started_at"})
    end

    it "should have many volumes" do
      Account.should have_many(:volumes).with_options({:extend=>[], :order=>"aws_created_at"})
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
    it "should call EC2Sync.sync_account with self" do
      EC2Sync.should_receive(:sync_account).with(@account)
      @account.sync_with_ec2
    end
  end

  describe "ids from account numbers hash" do
    before do
      @mock_accounts = [
        mock('account1', :id => 1, :aws_account_number => "foo"),
        mock('account2', :id => 2, :aws_account_number => "bar")
      ]
      Account.stub!(:all).and_return(@mock_accounts)
    end

    it "should only query the db once if class attribute isn't set or if refresh flag is set" do
      Account.should_receive(:all).once.and_return(@mock_accounts)
      Account.ids_from_account_numbers(true)
      Account.ids_from_account_numbers(false)
    end

    it "should query the db for all accounts and get their id and account number" do
      Account.should_receive(:all).with(:select => "aws_account_number, id").and_return(@mock_accounts)
      Account.ids_from_account_numbers(true)
    end

    it "should return a hash, with account numberrs as keys and ids as values" do
      Account.ids_from_account_numbers(true).should == {
        'foo' => 1,
        'bar' => 2
      }
    end
  end
end
