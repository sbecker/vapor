require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe EC2Sync::SecurityGroup do
  before do
    stub_account_with_ec2
    @account.stub!(:security_groups).and_return([])
    @ec2sync_security_group = EC2Sync::SecurityGroup.new(@account)
  end

  describe "get remotes" do
    it "should call describe_security_groups on the account's ec2 object" do
      @ec2.should_receive(:describe_security_groups).and_return([])
      @ec2sync_security_group.get_remotes
    end
  end

  describe "get locals" do
    it "should get a list of all security groups currently in the DB that belong to this account" do
      @account.security_groups.should_receive(:all).and_return([])
      @ec2sync_security_group.get_locals
    end
  end

  describe "new local" do
    it "should get a new security group scoped to the account" do
      @account.security_groups.should_receive(:new)
      @ec2sync_security_group.new_local
    end
  end

  describe "equality" do
    it "should compare security groups by both name and figerprint" do
      @ec2sync_security_group.is_equal?(
        mock('local', :name => "foo"),
        {:aws_group_name => "foo"}
      ).should be_true
    end

    it "should not be equal if names match but fingerprints do not" do
      @ec2sync_security_group.is_equal?(
        mock('local', :name => "foo"),
        {:aws_group_name => "bar"}
      ).should be_false
    end
  end

  describe "update from remote" do
    before do
      @local = ::SecurityGroup.new
      @remote = {
        :aws_group_name => "foo", 
        :aws_description => "desc", 
        :aws_owner => "owner", 
        :aws_perms => [
          {:owner => "000000000888", :group => "default"},
          {:to_port => "443", :protocol => "tcp",  :from_port => "443", :cidr_ips => "0.0.0.0/0"}
        ]
      }
    end

    it "should set the name" do
      @local.should_receive(:name=).with(@remote[:aws_group_name])
    end

    it "should set the description" do
      @local.should_receive(:description=).with(@remote[:aws_description])
    end

    it "should set the owner id" do
      @local.should_receive(:owner_id=).with(@remote[:aws_owner])
    end

    it "should set the permissions" do
      @local.should_receive(:permissions=).with(@remote[:aws_perms])
    end

    after do
      @ec2sync_security_group.update_from_remote(@local, @remote)
    end
  end

  describe "handle missing" do
    it "should delete security group from local db" do
      local = mock('local')
      local.should_receive(:destroy)

      @ec2sync_security_group.handle_missing(local)
    end
  end
end