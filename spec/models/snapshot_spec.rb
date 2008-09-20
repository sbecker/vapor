require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Snapshot do
  before(:each) do
    @valid_attributes = {
      :account_id     => "1",
      :aws_id         => "value for aws_id",
      :aws_progress   => "value for aws_progress",
      :aws_started_at => Time.now,
      :aws_status     => "value for aws_status",
      :aws_volume_id  => "value for aws_volume_id"
    }
  end

  it "should create a new instance given valid attributes" do
    Snapshot.create!(@valid_attributes)
  end

  describe "associations" do
    it "should belong to an account" do
      Snapshot.should belong_to(:account)
    end
  end

  describe "accessible attributes" do
    before do
      @snapshot = Snapshot.new(@valid_attributes)
    end

    it "should include 'aws_volume_id'" do
      @snapshot.aws_volume_id.should == @valid_attributes[:aws_volume_id]
    end

    it "should not include any other attributes" do
      inaccessible_attributes = @valid_attributes
      inaccessible_attributes.delete(:aws_volume_id)

      inaccessible_attributes.each_key do |key|
        @snapshot.send(key).should be_nil
      end
    end
  end

end
