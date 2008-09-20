require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Volume do
  before(:each) do
    @valid_attributes = {
      :account_id            => "1",
      :aws_attached_at       => Time.now,
      :aws_attachment_status => "value for aws_attachment_status",
      :aws_created_at        => Time.now,
      :aws_device            => "value for aws_device",
      :aws_id                => "value for aws_id",
      :aws_instance_id       => "value for aws_instance_id",
      :aws_size              => 1,
      :aws_status            => "value for aws_status",
      :snapshot_id           => "value for snapshot_id",
      :zone                  => "value for zone"
    }
  end

  it "should create a new instance given valid attributes" do
    Volume.create!(@valid_attributes)
  end

  describe "associations" do
    it "should belong to an account" do
      Volume.should belong_to(:account)
    end
  end

  describe "accessible attributes" do
    before do
      @volume = Volume.new(@valid_attributes)
      @accessible_attributes = %w( aws_device aws_instance_id aws_size snapshot_id zone ).map{|a| a.to_sym }
      @inaccessible_attributes = @valid_attributes.keys - @accessible_attributes
    end

    it "should set accessible attributes" do
      @accessible_attributes.each do |attr|
        @volume.send(attr).should == @valid_attributes[attr]
      end
    end

    it "should not set any other attributes" do
      @inaccessible_attributes.each do |attr|
        @volume.send(attr).should be_nil
      end
    end
  end

end
