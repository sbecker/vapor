require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe EC2Sync::KeyPair do
  before do
    stub_account_with_ec2
    @account.stub!(:key_pairs).and_return([])
    @ec2sync_key_pair = EC2Sync::KeyPair.new(@account)
  end

  def stub_ec2_response_full
    @ec2sync_key_pair.stub!(:ec2_key_pairs).and_return([
      mock("item", :keyName => "one-keypair", :keyFingerprint => "abc"),
      mock("item", :keyName => "two-keypair", :keyFingerprint => "xyz")
    ])
  end

  def stub_ec2_response_blank
    @ec2sync_key_pair.stub!(:ec2_key_pairs).and_return([])
  end

  describe "sync" do
    before do
      @ec2sync_key_pair.stub!(:create_and_update_listed)
      @ec2sync_key_pair.stub!(:delete_unlisted)
    end

    it "should create and update listed key_pairs" do
      @ec2sync_key_pair.should_receive(:create_and_update_listed)
    end

    it "should delete unlisted key_pairs" do
      @ec2sync_key_pair.should_receive(:delete_unlisted)
    end

    after do
      @ec2sync_key_pair.sync!
    end
  end

  describe "ec2 key pairs" do
    it "should call describe_keypairs on the account's ec2 object" do
      @ec2.should_receive(:describe_keypairs).and_return(mock("response", :keySet => mock("keySet", :item => [])))
      @ec2sync_key_pair.ec2_key_pairs
    end
  end

  describe "local key pairs" do
    it "should get a list of all key pairs currently in the DB that belong to this account" do
      @account.key_pairs.should_receive(:all).and_return([])
      @ec2sync_key_pair.local_key_pairs
    end
  end

  describe "create and update listed" do
    before do
      stub_ec2_response_full # ec2 contains 2 two records
      @account.key_pairs.stub!(:all).and_return([mock_model(::KeyPair, :name => "one-keypair", :fingerprint => "abc")]) # local db only contains one of them
      @account.key_pairs.stub!(:new).and_return(mock_model(::KeyPair))
      @ec2sync_key_pair.stub!(:update_from_ec2)
    end

    it "should create a new key pair for this account if ec2 key pair doesn't exist in db" do
      @account.key_pairs.should_receive(:new).once.and_return(mock("keypair"))
    end

    it "should update new or existing records with ec2 data" do
      @ec2sync_key_pair.should_receive(:update_from_ec2).twice
    end

    after do
      @ec2sync_key_pair.create_and_update_listed
    end
  end

  describe "delete unlisted" do
    it "should delete key pair from local db if it no longer exists on ec2" do
      stub_ec2_response_blank # ec2 contains no records
      missing_key_pair = mock_model(::KeyPair, :name => "long_gone", :fingerprint => "xyz")
      @ec2sync_key_pair.stub!(:local_key_pairs).and_return([missing_key_pair]) # local db contains a record

      missing_key_pair.should_receive(:destroy)

      @ec2sync_key_pair.delete_unlisted
    end
  end

  describe "update from ec2" do
    before do
      stub_ec2_response_full
      @key_pair = ::KeyPair.new
      @ec2_key_pair = @ec2sync_key_pair.ec2_key_pairs[0]
    end

    it "should set the name" do
      @key_pair.should_receive(:name=).with(@ec2_key_pair.keyName)
    end

    it "should set the fingerprint" do
      @key_pair.should_receive(:fingerprint=).with(@ec2_key_pair.keyFingerprint)
    end

    after do
      @ec2sync_key_pair.update_from_ec2(@key_pair, @ec2_key_pair)
    end
  end
end