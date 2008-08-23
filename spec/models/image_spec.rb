require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Image do
  before(:each) do
    @valid_attributes = {
      :architecture => "value for architecture",
      :aws_id => "value for aws_id",
      :description => "value for description",
      :is_public => false,
      :location => "value for location",
      :name => "value for name",
      :owner_id => "value for owner_id",
      :state => "value for state",
      :type => "value for type"
    }
  end

  it "should create a new instance given valid attributes" do
    Image.create!(@valid_attributes)
  end

  describe "named scopes" do
    # Want a better way to test this.
    it "should have an all_public named scope" do
      Image.singleton_methods.should include("all_public")
    end
  end

  describe "accessible attributes" do
    before do
      @image = Image.new(@valid_attributes)
    end

    it "should include 'name'" do
      @image.name.should == @valid_attributes[:name]
    end

    it "should include 'description'" do
      @image.description.should == @valid_attributes[:description]
    end

    it "should not include any other attributes" do
      inaccessible_attributes = @valid_attributes
      inaccessible_attributes.delete(:name)
      inaccessible_attributes.delete(:description)

      inaccessible_attributes.each_key do |key|
        @image.send(key).should be_nil
      end
    end
  end

  describe "ec2 integration" do

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
    end

    describe "refresh list for account" do
      before do
        @account = Account.new
        @account.id = 1
        @account.stub!(:ec2).and_return(@ec2)
      end

      def stub_ec2_image_response_full
        @ec2.stub!(:make_request).with('DescribeImages', {}).and_return(stub("response", :body => @describe_image_response_body, :is_a? => true))
      end

      def stub_ec2_image_response_blank
        @ec2.stub!(:describe_images).and_return(stub("response", :imagesSet => stub("imagesSet", :item => [])))
      end

      it "should call describe_images on the account's ec2 object" do
        @ec2.should_receive(:describe_images).and_return(stub("response", :imagesSet => stub("imagesSet", :item => [])))
        Image.refresh_list_for_account(@account)
      end

      it "should get a list of all images currently in the DB for this account" do
        stub_ec2_image_response_blank
        @account.should_receive(:images).and_return([])
        Image.refresh_list_for_account(@account)
      end

      it "should create records for ec2 images that don't exist in db" do
        stub_ec2_image_response_full
        images_for_account = [mock_model(Image, :aws_id => "ami-61a54008", :is_public= => true, :state= => true, :save => true)]
        @new_image = Image.new
        images_for_account.should_receive(:new).and_return(@new_image)
        @account.stub!(:images).and_return(images_for_account)

        Image.should_receive(:create_from_ec2).once

        Image.refresh_list_for_account(@account)
      end

      it "should update records for ec2 images that already exist in db" do
        stub_ec2_image_response_full
        @image1 = mock_model(Image, :aws_id => "ami-61a54008")
        @image2 = mock_model(Image, :aws_id => "ami-61a54009")
        images_for_account = [@image1, @image2]
        @account.stub!(:images).and_return(images_for_account)

        Image.should_receive(:update_from_ec2).twice

        Image.refresh_list_for_account(@account)
      end

      it "should mark db records as deregistered if they no longer exist on ec2" do
        stub_ec2_image_response_blank
        missing_image = mock_model(Image, :aws_id => "long_gone")
        missing_image.should_receive(:update_attribute).with(:state, "deregistered")
        @account.should_receive(:images).and_return([missing_image])

        Image.refresh_list_for_account(@account)
      end

     describe "create from ec2" do
       before do
         stub_ec2_image_response_full
         @image = Image.new
         @ec2_image = @ec2.describe_images.imagesSet.item[0]
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
         @image.should_receive(:type=).with(@ec2_image.imageType)
       end

       it "should save the image" do
         @image.should_receive(:save)
       end

       after do
         Image.create_from_ec2(@image, @ec2_image)
       end
     end

     describe "update from ec2" do
       before do
         stub_ec2_image_response_full
         @image = Image.new
         @ec2_image = @ec2.describe_images.imagesSet.item[0]
       end

       it "should set is_public" do
         @image.should_receive(:is_public=).with(@ec2_image.isPublic == "true")
       end

       it "should set the state" do
         @image.should_receive(:state=).with(@ec2_image.imageState)
       end

       it "should save the image" do
         @image.should_receive(:save)
       end

       after do
         Image.update_from_ec2(@image, @ec2_image)
       end
     end

    end
  end

end
