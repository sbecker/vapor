require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe EC2Sync::Address do
  before do
    stub_account_with_ec2
    @account.stub!(:addresses).and_return([])
    @ec2sync_address = EC2Sync::Address.new(@account)
  end

  describe "get remotes" do
    it "should call describe_addresses on the account's ec2 object" do
      @ec2.should_receive(:describe_addresses).and_return([])
      @ec2sync_address.get_remotes
    end
  end

  describe "get locals" do
    it "should get a list of all addresses currently in the DB that belong to this account" do
      @account.addresses.should_receive(:all).and_return([])
      @ec2sync_address.get_locals
    end
  end

  describe "new local" do
    it "should get a new address scoped to the account" do
      @account.addresses.should_receive(:new)
      @ec2sync_address.new_local
    end
  end

  describe "equality" do
    it "should compare addresses by public ip" do
      @ec2sync_address.is_equal?(
        mock('local', :public_ip => "1.2.3.4", :instance_id => "i-xyz"),
        {:public_ip => "1.2.3.4", :instance_id => "i-abc"}
      ).should be_true
    end

    it "should not be equal if public ip doesn't match" do
      @ec2sync_address.is_equal?(
        mock('local', :public_ip => "0.1.2.3", :instance_id => "i-xyz"),
        {:public_ip => "4.5.6.7", :instance_id => "i-xyz"}
      ).should be_false
    end
  end

  describe "update from remote" do
    before do
      @local = ::Address.new
      @remote = {:public_ip => "1.2.3.4", :instance_id => "i-xyz"}
    end

    it "should set the public ip" do
      @local.should_receive(:public_ip=).with(@remote[:public_ip])
    end

    it "should set the instance id" do
      @local.should_receive(:instance_id=).with(@remote[:instance_id])
    end

    after do
      @ec2sync_address.update_from_remote(@local, @remote)
    end
  end

  describe "handle missing" do
    it "should delete address from local db" do
      local = mock('local')
      local.should_receive(:destroy)

      @ec2sync_address.handle_missing(local)
    end
  end
end