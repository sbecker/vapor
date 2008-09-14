require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe EC2Sync::KeyPair do
  before do
    stub_account_with_ec2
    @account.stub!(:key_pairs).and_return([])
    @ec2sync_key_pair = EC2Sync::KeyPair.new(@account)
  end

  describe "get remotes" do
    it "should call describe_key_pairs on the account's ec2 object" do
      @ec2.should_receive(:describe_key_pairs).and_return([])
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
        {:aws_key_name => "foo", :aws_fingerprint => "xyz"}
      ).should be_true
    end

    it "should not be equal if names match but fingerprints do not" do
      @ec2sync_key_pair.is_equal?(
        mock('local', :name => "foo", :fingerprint => "xyz"),
        {:aws_key_name => "foo", :aws_fingerprint => "abc"}
      ).should be_false
    end

    it "should not be equal if fingerprints match but names do not" do
      @ec2sync_key_pair.is_equal?(
        mock('local', :name => "foo", :fingerprint => "xyz"),
        {:aws_key_name => "bar", :aws_fingerprint => "xyz"}
      ).should be_false
    end

    it "should not be equal if neither name or fingerprint match" do
      @ec2sync_key_pair.is_equal?(
        mock('local', :name => "foo", :fingerprint => "xyz"),
        {:aws_key_name => "bar", :aws_fingerprint => "abc"}
      ).should be_false
    end
  end

  describe "update from remote" do
    before do
      @local = ::KeyPair.new
      @remote = {:aws_key_name => "foo", :aws_fingerprint => "xyz"}
    end

    it "should set the name" do
      @local.should_receive(:name=).with(@remote[:aws_key_name])
    end

    it "should set the fingerprint" do
      @local.should_receive(:fingerprint=).with(@remote[:aws_fingerprint])
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