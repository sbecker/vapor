require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe EC2Sync::Image do
  before do
    # borrowed from the amazon-ec2 gem test suite
    @describe_image_response_body = <<-RESPONSE
    <DescribeImagesResponse xmlns="http://ec2.amazonaws.com/doc/2007-03-01">
      <imagesSet>
        <item>
          <imageId>ami-61a54008</imageId>
          <imageLocation>foobar1/image.manifest.xml</imageLocation>
          <imageState>available</imageState>
          <imageOwnerId>AAAATLBUXIEON5NQVUUX6OMPWBZIAAAA</imageOwnerId>
          <isPublic>true</isPublic>
          <productCodes>
            <item>
              <productCode>774F4FF8</productCode>
            </item>
          </productCodes>
          <imageType>machine</imageType>
          <architecture>i386</architecture>
        </item>
        <item>
          <imageId>ami-61a54009</imageId>
          <imageLocation>foobar2/image.manifest.xml</imageLocation>
          <imageState>deregistered</imageState>
          <imageOwnerId>ZZZZTLBUXIEON5NQVUUX6OMPWBZIZZZZ</imageOwnerId>
          <isPublic>false</isPublic>
          <imageType>ramdisk</imageType>
          <architecture>x86_64</architecture>
        </item>
      </imagesSet>
    </DescribeImagesResponse>
    RESPONSE

    @ec2 = EC2::Base.new(:access_key_id => "not a secret", :secret_access_key => "not a key")

    @account = Account.new
    @account.id = 1
    @account.aws_account_number = "AAAATLBUXIEON5NQVUUX6OMPWBZIAAAA"
    @account.stub!(:ec2).and_return(@ec2)

    Account.stub!(:all).and_return([@account])
    @ec2sync_image = EC2Sync::Image.new(@account)
  end

  def stub_ec2_image_response_full
    @ec2.stub!(:make_request).with('DescribeImages', {}).and_return(stub("response", :body => @describe_image_response_body, :is_a? => true))
  end

  def stub_ec2_image_response_blank
    @ec2.stub!(:describe_images).and_return(stub("response", :imagesSet => stub("imagesSet", :item => [])))
  end

  def mock_image(options={})
    mock_model(Image, {
      :aws_id        => "ami-61a54008",
      :aws_id=       => true,
      :account_id=   => true,
      :architecture= => true,
      :is_public=    => true,
      :state=        => true,
      :location=     => true,
      :image_type=   => true,
      :owner_id=     => true,
      :save          => true
    }.merge(options))
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
      stub_ec2_image_response_full # ec2 returns both ami-61a54008 AND ami-61a54008
      Image.stub!(:available).and_return(mock("available", :all => [mock_image(:aws_id => "ami-61a54008")])) # local db only contains one of them
    end

    it "should create a new images for this account if ec2 images doesn't exist in db" do
      Image.should_receive(:new).once.and_return(mock_image)
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
      @ec2_image = @ec2.describe_images.imagesSet.item[0]
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
