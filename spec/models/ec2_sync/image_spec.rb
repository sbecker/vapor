require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe EC2Sync::Image do
  before do
    stub_account_with_ec2
    Account.stub!(:all).and_return([@account])
    @ec2sync_image = EC2Sync::Image.new(@account)
  end

  describe "get remotes" do
    it "should call describe_images on the account's ec2 object" do
      @ec2.should_receive(:describe_images).and_return([])
      @ec2sync_image.get_remotes
    end
  end

  describe "get locals" do
    it "should get a list of all 'available' images currently in the DB that are either public or belong to this account" do
      available = mock("available")
      Image.stub!(:available).and_return(available)
      available.should_receive(:all).with(:conditions => ["is_public = ? OR account_id = ?", true, @account.id]).and_return([])
      @ec2sync_image.get_locals
    end
  end

  describe "new local" do
    it "should return a new instance of Image " do
      Image.should_receive(:new).and_return(mock_model(Image))
      @ec2sync_image.new_local
    end
  end

  describe "equality" do
    it "should compare local aws_id to remote imageId" do
      @ec2sync_image.is_equal?(mock("local", :aws_id => "123"), {:aws_id => "123"}).should be_true
      @ec2sync_image.is_equal?(mock("local", :aws_id => "123"), {:aws_id => "456"}).should be_false
    end
  end

  describe "update from remote" do
    before do
      @local = Image.new
      @remote = {
        :aws_id           => "ami-61a54008",
        :aws_location     => "foobar1/image.manifest.xml",
        :aws_state        => "available",
        :aws_owner        => "AAAATLBUXIEON5NQVUUX6OMPWBZIAAAA",
        :aws_is_public    => true,
        :aws_image_type   => "machine",
        :aws_architecture => "i386"
      }
    end

    it "should set the account_id if the image owner id matches any account's aws_account_number in the database" do
      @local.should_receive(:account_id=).with(@account.id)
    end

    it "should set the account_id to nil if the image owner id does not match the account's aws_account_number" do
      @remote[:aws_owner] = "not_a_match"
      @local.should_receive(:account_id=).with(nil)
    end

    it "should set the architecture" do
      @local.should_receive(:architecture=).with(@remote[:aws_architecture])
    end

    it "should set the aws id" do
      @local.should_receive(:aws_id=).with(@remote[:aws_id])
    end

    it "should set is_public" do
      @local.should_receive(:is_public=).with(@remote[:aws_is_public])
    end

    it "should set the location" do
      @local.should_receive(:location=).with(@remote[:aws_location])
    end

    it "should set the owner_id" do
      @local.should_receive(:owner_id=).with(@remote[:aws_owner])
    end

    it "should set the state" do
      @local.should_receive(:state=).with(@remote[:aws_state])
    end

    it "should set the type" do
      @local.should_receive(:image_type=).with(@remote[:aws_image_type])
    end

    after do
      @ec2sync_image.update_from_remote(@local, @remote)
    end
  end

  describe "handle missing" do
    it "should mark db records as deregistered if they no longer exist on ec2" do
      local = mock('local')
      local.should_receive(:update_attribute).with(:state, "deregistered")

      @ec2sync_image.handle_missing(local)
    end
  end

end
