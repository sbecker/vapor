require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Image do
  before(:each) do
    @valid_attributes = {
      :aws_architecture => "value for aws_architecture",
      :aws_id           => "value for aws_id",
      :aws_is_public    => false,
      :aws_location     => "value for aws_location",
      :aws_owner        => "value for aws_owner",
      :aws_state        => "value for aws_state",
      :aws_image_type   => "value for aws_image_type",
      :description      => "value for description",
      :name             => "value for name"
    }
  end

  it "should create a new instance given valid attributes" do
    Image.create!(@valid_attributes)
  end

  describe "associations" do
    it "should belong to an account" do
      Image.should belong_to(:account)
    end
  end

  describe "named scopes" do

    it "should have an 'are_public' named scope where 'aws_is_public' is true" do
      Image.should have_named_scope(:are_public, :order => 'aws_location', :conditions => {:aws_is_public => true})
    end

    it "should have a 'not_public' named scope where 'aws_is_public' is false" do
      Image.should have_named_scope(:not_public, :order => 'aws_location', :conditions => {:aws_is_public => false})
    end

    it "should have an 'available' named scope where 'aws_state' equals 'available'" do
      Image.should have_named_scope(:available,  :order => 'aws_location', :conditions => {:aws_state => 'available'})
    end

    it "should have a 'machines' named scope where 'aws_image_type' is 'machine'" do
      Image.should have_named_scope(:machines, :order => 'aws_location', :conditions => {:aws_image_type => 'machine'})
    end

    it "should have a 'kernels' named scope where 'aws_image_type' is 'kernel'" do
      Image.should have_named_scope(:kernels, :order => 'aws_location', :conditions => {:aws_image_type => 'kernel'})
    end

    it "should have a 'ramdisks' named scope where 'aws_image_type' is 'ramdisk'" do
      Image.should have_named_scope(:ramdisks, :order => 'aws_location', :conditions => {:aws_image_type => 'ramdisk'})
    end

    it "should have a 'for_select' named scope which only returns the 'aws_id' and 'aws_location'" do
      Image.should have_named_scope(:for_select, :select => 'aws_id, aws_location')
    end

    it "should have a 'allowed_for' named scope where either 'aws_is_public' is true or 'account_id' matches the id for the passed in account" do
      Image.should have_named_scope(:allowed_for,
        lambda { |account| { :conditions => ["aws_is_public = ? OR account_id = ?", true, account.id] }},
        mock('Account', :id => 1))
    end

  end

  describe "accessible attributes" do
    before do
      @image = Image.new(@valid_attributes)
      @accessible_attributes = %w( name description ).map{|a| a.to_sym }
      @inaccessible_attributes = @valid_attributes.keys - @accessible_attributes
    end

    it "should set accessible attributes - name and description" do
      @accessible_attributes.each do |attr|
        @image.send(attr).should == @valid_attributes[attr]
      end
    end

    it "should not set any other attributes" do
      @inaccessible_attributes.each do |attr|
        @image.send(attr).should be_nil
      end
    end
  end

  describe "others" do
    it "should find images that are not in the standard vendor list and don't belong to the current user's account" do
      account_id = 1
      Image.should_receive(:all).with(:conditions => "(account_id != #{account_id} OR account_id IS NULL)" +
        " AND aws_owner != '#{Account::Vendors::Alestic}'" +
        " AND aws_owner != '#{Account::Vendors::Amazon}'" +
        " AND aws_owner != '#{Account::Vendors::RBuilder}'" +
        " AND aws_owner != '#{Account::Vendors::RedHat}'" +
        " AND aws_owner != '#{Account::Vendors::RightScale}'" +
        " AND aws_owner != '#{Account::Vendors::Scalr}'"
      )
      Image.others(account_id)
    end
  end

  describe "setting aws_owner" do
    before do
      @image = Image.new
    end

    it "should also set the account id" do
      @image.should_receive(:account_id=)
    end

    it "should query the Account model for the account id from the supplied aws_owner string" do
      Account.should_receive(:ids_from_account_numbers).and_return({})
    end

    it "should set the account id to a value if the aws owner matches a key in the hash" do
      Account.stub!(:ids_from_account_numbers).and_return({'foo' => 25})
      @image.should_receive(:account_id=).with(25)
    end

    it "should set the account id to nil if the aws owner does not matche a key in the hash" do
      Account.stub!(:ids_from_account_numbers).and_return({'bar' => 25})
      @image.should_receive(:account_id=).with(nil)
    end

    after do
      @image.aws_owner = "foo"
    end
  end

  describe "aws location short" do
    it "should remove the meaningless '.manifest.xml' from the end of the name and titleize it" do
      image = Image.new(:aws_location => 'redhat-cloud/RHEL-5-Server/5.1/i386/kernels/kernel-2.6.18-53.1.4.el5xen.manifest.xml')
      image.aws_location_short.should == 'Redhat Cloud/Rhel 5 Server/5.1/I386/Kernels/Kernel 2.6.18 53.1.4.El5xen'
    end
  end

end
