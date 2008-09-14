require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe EC2Sync::AvailabilityZone do
  before do
    stub_account_with_ec2
    @account.stub!(:availability_zones).and_return([])
    @ec2sync_availability_zone = EC2Sync::AvailabilityZone.new(@account)
  end

  describe "get remotes" do
    it "should call describe_availability_zones on the account's ec2 object" do
      @ec2.should_receive(:describe_availability_zones).and_return([])
      @ec2sync_availability_zone.get_remotes
    end
  end

  describe "get locals" do
    it "should get a list of all availability zones currently in the DB that belong to this account" do
      @account.availability_zones.should_receive(:all).and_return([])
      @ec2sync_availability_zone.get_locals
    end
  end

  describe "new local" do
    it "should get a new availability zone scoped to the account" do
      @account.availability_zones.should_receive(:new)
      @ec2sync_availability_zone.new_local
    end
  end

  describe "equality" do
    it "should compare availability zones by name" do
      @ec2sync_availability_zone.is_equal?(
        mock('local', :name => "foo", :state => "xyz"),
        {:zone_name => "foo", :zone_state => "xyz"}
      ).should be_true
    end

    it "should not be equal if states match but names do not" do
      @ec2sync_availability_zone.is_equal?(
        mock('local', :name => "foo", :state => "xyz"),
        {:zone_name => "bar", :zone_state => "xyz"}
      ).should be_false
    end
  end

  describe "update from remote" do
    before do
      @local = ::AvailabilityZone.new
      @remote = {:zone_name => "foo", :zone_state => "xyz"}
    end

    it "should set the name" do
      @local.should_receive(:name=).with(@remote[:zone_name])
    end

    it "should set the state" do
      @local.should_receive(:state=).with(@remote[:zone_state])
    end

    after do
      @ec2sync_availability_zone.update_from_remote(@local, @remote)
    end
  end

  describe "handle missing" do
    it "should delete availability zone from local db" do
      local = mock('local')
      local.should_receive(:destroy)

      @ec2sync_availability_zone.handle_missing(local)
    end
  end
end