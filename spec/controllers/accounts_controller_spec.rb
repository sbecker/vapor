require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AccountsController do
  before do
    stub_logged_in
  end

  def mock_account(stubs={})
    @mock_account ||= mock_model(Account, stubs)
  end

  describe "responding to GET show" do

    it "should expose the requested account as @account" do
      @current_user.should_receive(:account).and_return(mock_account)
      get :show
      assigns[:account].should equal(mock_account)
    end

    it "should redirect to the new action if @account doesn't exist yet" do
      @current_user.should_receive(:account).and_return(nil)
      get :show
      response.should redirect_to(new_account_path)
    end
    
    describe "with mime type of xml" do

      it "should render the requested account as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        @current_user.should_receive(:account).and_return(mock_account)
        mock_account.should_receive(:to_xml).and_return("generated XML")
        get :show
        response.body.should == "generated XML"
      end

    end

  end

  describe "responding to GET new" do

    it "should expose a new account as @account" do
      @current_user.should_receive(:build_account).and_return(mock_account)
      get :new
      assigns[:account].should equal(mock_account)
    end

  end

  describe "responding to GET edit" do
  
    it "should expose the requested account as @account" do
      @current_user.should_receive(:account).and_return(mock_account)
      get :edit
      assigns[:account].should equal(mock_account)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do
      before do
        @current_user.stub!(:save)
      end
      
      it "should expose a newly created account as @account" do
        @current_user.should_receive(:build_account).with({'these' => 'params'}).and_return(mock_account(:save => true))
        post :create, :account => {:these => 'params'}
        assigns(:account).should equal(mock_account)
      end

      it "should redirect to the created account" do
        @current_user.stub!(:build_account).and_return(mock_account(:save => true))
        post :create, :account => {}
        response.should redirect_to(account_path)
      end
      
      it "should save the current user after successfully saving the account" do
        @current_user.stub!(:build_account).and_return(mock_account(:save => true))
        @current_user.should_receive(:save)
        post :create, :account => {}
      end

    end
    
    describe "with invalid params" do

      it "should expose a newly created but unsaved account as @account" do
        @current_user.stub!(:build_account).with({'these' => 'params'}).and_return(mock_account(:save => false))
        post :create, :account => {:these => 'params'}
        assigns(:account).should equal(mock_account)
      end

      it "should re-render the 'new' template" do
        @current_user.stub!(:build_account).and_return(mock_account(:save => false))
        post :create, :account => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to PUT udpate" do

    describe "with valid params" do

      it "should update the requested account" do
        @current_user.should_receive(:account).and_return(mock_account)
        mock_account.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :account => {:these => 'params'}
      end

      it "should expose the requested account as @account" do
        @current_user.stub!(:account).and_return(mock_account(:update_attributes => true))
        put :update, :id => "1"
        assigns(:account).should equal(mock_account)
      end

      it "should redirect to the account" do
        @current_user.stub!(:account).and_return(mock_account(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(account_path)
      end

    end
    
    describe "with invalid params" do

      it "should update the requested account" do
        @current_user.should_receive(:account).and_return(mock_account)
        mock_account.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :account => {:these => 'params'}
      end

      it "should expose the account as @account" do
        @current_user.stub!(:account).and_return(mock_account(:update_attributes => false))
        put :update, :id => "1"
        assigns(:account).should equal(mock_account)
      end

      it "should re-render the 'edit' template" do
        @current_user.stub!(:account).and_return(mock_account(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested account" do
      @current_user.should_receive(:account).and_return(mock_account)
      mock_account.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "should redirect to the accounts list" do
      @current_user.stub!(:account).and_return(mock_account(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(account_path)
    end

  end

  describe "responding to POST sync" do
    before do
      account = mock_model(Account)
      account.stub!(:sync_with_ec2)
      @current_user.stub!(:account).and_return(account)
    end

    it "should call sync_with_ec2 on current user's account" do
      @current_user.account.should_receive(:sync_with_ec2)
      post :sync
    end

    it "should redirect to dashboard page" do
      post :sync
      response.should redirect_to(dashboard_path)
    end
  end

end
