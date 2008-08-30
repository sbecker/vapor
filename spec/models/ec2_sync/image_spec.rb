require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe EC2Sync::Image do
  before do
    stub_account_with_ec2
    Account.stub!(:all).and_return([@account])
    @ec2sync_image = EC2Sync::Image.new(@account)
  end

  def stub_ec2_image_response_full
    @ec2sync_image.stub!(:ec2_images).and_return([
      mock("item",
        :imageId       => "ami-61a54008",
        :imageLocation => "foobar1/image.manifest.xml",
        :imageState    => "available",
        :imageOwnerId  => "AAAATLBUXIEON5NQVUUX6OMPWBZIAAAA",
        :isPublic      => "true",
        :productCodes  => mock("productCodes", :item => [mock("item", :productCode => "774F4FF8")]),
        :imageType     => "machine",
        :architecture  => "i386"
      ),
      mock("item",
        :imageId       => "ami-61a54009",
        :imageLocation => "foobar2/image.manifest.xml",
        :imageState    => "deregistered",
        :imageOwnerId  => "ZZZZTLBUXIEON5NQVUUX6OMPWBZIZZZZ",
        :isPublic      => "false",
        :imageType     => "ramdisk",
        :architecture  => "x86_64"
      )
    ])
  end

  def stub_ec2_image_response_blank
    @ec2sync_image.stub!(:ec2_images).and_return([])
  end

  describe "sync" do
    before do
      @ec2sync_image.stub!(:create_and_update_listed)
      @ec2sync_image.stub!(:deregister_unlisted)
    end

    it "should create and update listed images" do
      @ec2sync_image.should_receive(:create_and_update_listed)
    end

    it "should deregister unlisted images" do
      @ec2sync_image.should_receive(:deregister_unlisted)
    end

    after do
      @ec2sync_image.sync!
    end
  end

  describe "ec2 images" do
    it "should call describe_images on the account's ec2 object" do
      @ec2.should_receive(:describe_images).and_return(stub("response", :imagesSet => stub("imagesSet", :item => [])))
      @ec2sync_image.ec2_images
    end
  end

  describe "local images" do
    it "should get a list of all 'available' images currently in the DB that are either public or belong to this account" do
      available = mock("available")
      Image.stub!(:available).and_return(available)
      available.should_receive(:all).with(:conditions => ["is_public = ? OR account_id = ?", true, @account.id]).and_return([])
      @ec2sync_image.local_images
    end
  end

  describe "create and update listed" do
    before do
      stub_ec2_image_response_full # ec2 returns two records
      Image.stub!(:available).and_return(mock("available", :all => [mock_model(Image, :aws_id => "ami-61a54008")])) # local db only contains one of them
      @ec2sync_image.stub!(:update_from_ec2)
    end

    it "should create a new image for this account if ec2 image doesn't exist in db" do
      Image.should_receive(:new).once
    end

    it "should update new or existing records with ec2 data" do
      @ec2sync_image.should_receive(:update_from_ec2).twice
    end

    after do
      @ec2sync_image.create_and_update_listed
    end
  end

  describe "deregister unlisted" do
    it "should mark db records as deregistered if they no longer exist on ec2" do
      stub_ec2_image_response_blank # ec2 returns an empty array
      missing_image = mock_model(Image, :aws_id => "long_gone") # local db contains a record
      Image.stub!(:available).and_return(mock("available", :all => [missing_image]))

      missing_image.should_receive(:update_attribute).with(:state, "deregistered")

      @ec2sync_image.deregister_unlisted
    end
  end

  describe "update from ec2" do
    before do
      stub_ec2_image_response_full
      @image = Image.new
      @ec2_image = @ec2sync_image.ec2_images[0]
    end

    it "should set the account_id if the image owner id matches any account's aws_account_number in the database" do
      @image.should_receive(:account_id=).with(@account.id)
    end

    it "should set the account_id to nil if the image owner id does not match the account's aws_account_number" do
      @ec2_image.stub!(:imageOwnerId).and_return("not_a_match")
      @image.should_receive(:account_id=).with(nil)
    end

    it "should set the architecture" do
      @image.should_receive(:architecture=).with(@ec2_image.architecture)
    end

    it "should set the aws id" do
      @image.should_receive(:aws_id=).with(@ec2_image.imageId)
    end

    it "should set is_public" do
      @image.should_receive(:is_public=).with(@ec2_image.isPublic == "true")
    end

    it "should set the location" do
      @image.should_receive(:location=).with(@ec2_image.imageLocation)
    end

    it "should set the owner_id" do
      @image.should_receive(:owner_id=).with(@ec2_image.imageOwnerId)
    end

    it "should set the state" do
      @image.should_receive(:state=).with(@ec2_image.imageState)
    end

    it "should set the type" do
      @image.should_receive(:image_type=).with(@ec2_image.imageType)
    end

    it "should save the image" do
      @image.should_receive(:save)
    end

    after do
      @ec2sync_image.update_from_ec2(@image, @ec2_image)
    end
  end
end
