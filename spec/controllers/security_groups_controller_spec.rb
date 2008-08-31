require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SecurityGroupsController do
  before do
    stub_logged_in
    @current_account.stub!(:security_groups).and_return([])
  end

  def mock_security_group(stubs={})
    @mock_security_group ||= mock_model(SecurityGroup, stubs)
  end
  
  describe "responding to GET index" do

    it "should expose all security_groups as @security_groups" do
      @current_account.security_groups.should_receive(:all).and_return([mock_security_group])
      get :index
      assigns[:security_groups].should == [mock_security_group]
    end

    describe "with mime type of xml" do
  
      it "should render all security_groups as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        @current_account.security_groups.should_receive(:all).and_return(security_groups = mock("Array of SecurityGroups"))
        security_groups.should_receive(:to_xml).and_return("generated XML")
        get :index
        response.body.should == "generated XML"
      end
    
    end

  end

  describe "responding to GET show" do

    it "should expose the requested security_group as @security_group" do
      @current_account.security_groups.should_receive(:find).with("37").and_return(mock_security_group)
      get :show, :id => "37"
      assigns[:security_group].should equal(mock_security_group)
    end
    
    describe "with mime type of xml" do

      it "should render the requested security_group as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        @current_account.security_groups.should_receive(:find).with("37").and_return(mock_security_group)
        mock_security_group.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37"
        response.body.should == "generated XML"
      end

    end
    
  end

  describe "responding to GET new" do
  
    it "should expose a new security_group as @security_group" do
      @current_account.security_groups.should_receive(:new).and_return(mock_security_group)
      get :new
      assigns[:security_group].should equal(mock_security_group)
    end

  end

  describe "responding to GET edit" do
  
    it "should expose the requested security_group as @security_group" do
      @current_account.security_groups.should_receive(:find).with("37").and_return(mock_security_group)
      get :edit, :id => "37"
      assigns[:security_group].should equal(mock_security_group)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do
      
      it "should expose a newly created security_group as @security_group" do
        @current_account.security_groups.should_receive(:new).with({'these' => 'params'}).and_return(mock_security_group(:save => true))
        post :create, :security_group => {:these => 'params'}
        assigns(:security_group).should equal(mock_security_group)
      end

      it "should redirect to the created security_group" do
        @current_account.security_groups.stub!(:new).and_return(mock_security_group(:save => true))
        post :create, :security_group => {}
        response.should redirect_to(security_group_path(mock_security_group))
      end
      
    end
    
    describe "with invalid params" do

      it "should expose a newly created but unsaved security_group as @security_group" do
        @current_account.security_groups.stub!(:new).with({'these' => 'params'}).and_return(mock_security_group(:save => false))
        post :create, :security_group => {:these => 'params'}
        assigns(:security_group).should equal(mock_security_group)
      end

      it "should re-render the 'new' template" do
        @current_account.security_groups.stub!(:new).and_return(mock_security_group(:save => false))
        post :create, :security_group => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to PUT udpate" do

    describe "with valid params" do

      it "should update the requested security_group" do
        @current_account.security_groups.should_receive(:find).with("37").and_return(mock_security_group)
        mock_security_group.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :security_group => {:these => 'params'}
      end

      it "should expose the requested security_group as @security_group" do
        @current_account.security_groups.stub!(:find).and_return(mock_security_group(:update_attributes => true))
        put :update, :id => "1"
        assigns(:security_group).should equal(mock_security_group)
      end

      it "should redirect to the security_group" do
        @current_account.security_groups.stub!(:find).and_return(mock_security_group(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(security_group_path(mock_security_group))
      end

    end
    
    describe "with invalid params" do

      it "should update the requested security_group" do
        @current_account.security_groups.should_receive(:find).with("37").and_return(mock_security_group)
        mock_security_group.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :security_group => {:these => 'params'}
      end

      it "should expose the security_group as @security_group" do
        @current_account.security_groups.stub!(:find).and_return(mock_security_group(:update_attributes => false))
        put :update, :id => "1"
        assigns(:security_group).should equal(mock_security_group)
      end

      it "should re-render the 'edit' template" do
        @current_account.security_groups.stub!(:find).and_return(mock_security_group(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested security_group" do
      @current_account.security_groups.should_receive(:find).with("37").and_return(mock_security_group)
      mock_security_group.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "should redirect to the security_groups list" do
      @current_account.security_groups.stub!(:find).and_return(mock_security_group(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(security_groups_path)
    end

  end

end
