require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe EC2Sync::KeyPair do
  before do
    stub_account_with_ec2
    @account.stub!(:key_pairs).and_return([])
    @ec2sync_key_pair = EC2Sync::KeyPair.new(@account)
  end

  describe "get remotes" do
    it "should call describe_keypairs on the account's ec2 object" do
      @ec2.should_receive(:describe_keypairs).and_return(mock("response", :keySet => mock("keySet", :item => [])))
      @ec2sync_key_pair.get_remotes
    end
  end

  describe "get locals" do
    it "should get a list of all key pairs currently in the DB that belong to this account" do
      @account.key_pairs.should_receive(:all).and_return([])
      @ec2sync_key_pair.get_locals
    end
  end

  describe "new local" do
    it "should get a new key pair scoped to the account" do
      @account.key_pairs.should_receive(:new)
      @ec2sync_key_pair.new_local
    end
  end

  describe "equality" do
    it "should compare key pairs by both name and figerprint" do
      @ec2sync_key_pair.is_equal?(
        mock('local', :name => "foo", :fingerprint => "xyz"),
        mock('remote', :keyName => "foo", :keyFingerprint => "xyz")
      ).should be_true
    end

    it "should not be equal if names match but fingerprints do not" do
      @ec2sync_key_pair.is_equal?(
        mock('local', :name => "foo", :fingerprint => "xyz"),
        mock('remote', :keyName => "foo", :keyFingerprint => "abc")
      ).should be_false
    end

    it "should not be equal if fingerprints match but names do not" do
      @ec2sync_key_pair.is_equal?(
        mock('local', :name => "foo", :fingerprint => "xyz"),
        mock('remote', :keyName => "bar", :keyFingerprint => "xyz")
      ).should be_false
    end

    it "should not be equal if neither name or fingerprint match" do
      @ec2sync_key_pair.is_equal?(
        mock('local', :name => "foo", :fingerprint => "xyz"),
        mock('remote', :keyName => "bar", :keyFingerprint => "abc")
      ).should be_false
    end
  end

  describe "update from remote" do
    before do
      @local = ::KeyPair.new
      @remote = mock('item', :keyName => "foo", :keyFingerprint => "xyz")
    end

    it "should set the name" do
      @local.should_receive(:name=).with(@remote.keyName)
    end

    it "should set the fingerprint" do
      @local.should_receive(:fingerprint=).with(@remote.keyFingerprint)
    end

    after do
      @ec2sync_key_pair.update_from_remote(@local, @remote)
    end
  end

  describe "handle missing" do
    it "should delete key pair from local db" do
      local = mock('local')
      local.should_receive(:destroy)

      @ec2sync_key_pair.handle_missing(local)
    end
  end
end