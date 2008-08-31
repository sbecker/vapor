require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe DashboardController do
  before do
    stub_logged_in
  end

  describe "GET 'index'" do
    before do
      @current_account.stub!(:images).and_return(mock("Array", :count => 1))
      @current_account.stub!(:key_pairs).and_return(mock("Array", :count => 2))
      @current_account.stub!(:security_groups).and_return(mock("Array", :count => 3))
    end

    it "should be successful" do
      get 'index'
      response.should be_success
    end

    describe "EC2 stats for current account" do

      it "should expose stats as @ec2_stats" do
        get 'index'
        assigns[:ec2_stats].should == {:image_count => 1, :key_pair_count => 2, :security_group_count => 3}
      end

      it "should get a count of images" do
        @current_account.images.should_receive(:count).and_return(1)
        get 'index'
      end

      it "should get a count of key pairs" do
        @current_account.key_pairs.should_receive(:count).and_return(1)
        get 'index'
      end

      it "should get a count of security groups" do
        @current_account.security_groups.should_receive(:count).and_return(1)
        get 'index'
      end

    end

  end

end
