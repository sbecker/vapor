require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe DashboardController do
  before do
    stub_logged_in
  end

  describe "GET 'index'" do
    before do
      @current_account.stub!(:images).and_return(mock("Images", :count => 1))
    end

    it "should be successful" do
      get 'index'
      response.should be_success
    end

    describe "EC2 stats" do

      it "should expose stats as @ec2_stats" do
        get 'index'
        assigns[:ec2_stats].should == {:image_count => 1}
      end

      it "should get a count of the current user's images" do
        @current_account.images.should_receive(:count).and_return(1)
        get 'index'
      end

    end

  end

end
