require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe KeyPairsController do

  before do
    stub_logged_in
    @current_account.stub!(:key_pairs).and_return([])
  end

  def mock_key_pair(stubs={})
    @mock_key_pair ||= mock_model(KeyPair, stubs)
  end

  describe "responding to GET index" do

    it "should expose all key_pairs as @key_pairs" do
      @current_account.key_pairs.should_receive(:all).and_return([mock_key_pair])
      get :index
      assigns[:key_pairs].should == [mock_key_pair]
    end

    describe "with mime type of xml" do

      it "should render all key_pairs as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        @current_account.key_pairs.should_receive(:all).and_return(key_pairs = mock("Array of KeyPairs"))
        key_pairs.should_receive(:to_xml).and_return("generated XML")
        get :index
        response.body.should == "generated XML"
      end

    end

  end

  describe "responding to POST sync" do
    before do
      account = mock_model(Account)
      account.stub!(:sync_key_pairs_with_ec2)
      @current_user.stub!(:account).and_return(account)
    end

    it "should call sync_images_with_ec2 on current user's account" do
      @current_user.account.should_receive(:sync_key_pairs_with_ec2)
      post :sync
    end

    it "should redirect to index" do
      post :sync
      response.should redirect_to(key_pairs_path)
    end
  end

  describe "responding to GET show" do

    it "should expose the requested key_pair as @key_pair" do
      @current_account.key_pairs.should_receive(:find).with("37").and_return(mock_key_pair)
      get :show, :id => "37"
      assigns[:key_pair].should equal(mock_key_pair)
    end

    describe "with mime type of xml" do

      it "should render the requested key_pair as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        @current_account.key_pairs.should_receive(:find).with("37").and_return(mock_key_pair)
        mock_key_pair.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37"
        response.body.should == "generated XML"
      end

    end

  end

  describe "responding to GET new" do

    it "should expose a new key_pair as @key_pair" do
      @current_account.key_pairs.should_receive(:new).and_return(mock_key_pair)
      get :new
      assigns[:key_pair].should equal(mock_key_pair)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do

      it "should expose a newly created key_pair as @key_pair" do
        @current_account.key_pairs.should_receive(:new).with({'these' => 'params'}).and_return(mock_key_pair(:save => true))
        post :create, :key_pair => {:these => 'params'}
        assigns(:key_pair).should equal(mock_key_pair)
      end

      it "should redirect to the created key_pair" do
        @current_account.key_pairs.stub!(:new).and_return(mock_key_pair(:save => true))
        post :create, :key_pair => {}
        response.should redirect_to(key_pair_path(mock_key_pair))
      end

    end

    describe "with invalid params" do

      it "should expose a newly created but unsaved key_pair as @key_pair" do
        @current_account.key_pairs.stub!(:new).with({'these' => 'params'}).and_return(mock_key_pair(:save => false))
        post :create, :key_pair => {:these => 'params'}
        assigns(:key_pair).should equal(mock_key_pair)
      end

      it "should re-render the 'new' template" do
        @current_account.key_pairs.stub!(:new).and_return(mock_key_pair(:save => false))
        post :create, :key_pair => {}
        response.should render_template('new')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested key_pair" do
      @current_account.key_pairs.should_receive(:find).with("37").and_return(mock_key_pair)
      mock_key_pair.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "should redirect to the key_pairs list" do
      @current_account.key_pairs.stub!(:find).and_return(mock_key_pair(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(key_pairs_path)
    end

  end

end
