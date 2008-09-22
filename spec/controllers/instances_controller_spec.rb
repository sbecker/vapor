require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe InstancesController do

  before do
    stub_logged_in
    @account_instances = mock("Instance")
    @current_account.stub!(:instances => @account_instances)
  end

  def mock_instance(stubs={})
    @mock_instance ||= mock_model(Instance, stubs)
  end
  
  describe "responding to GET index" do

    it "should expose all instances as @instances" do
      @account_instances.should_receive(:all).and_return([mock_instance])
      get :index
      assigns[:instances].should == [mock_instance]
    end

    describe "with mime type of xml" do
  
      it "should render all instances as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        @account_instances.should_receive(:all).and_return(instances = mock("Array of Instances"))
        instances.should_receive(:to_xml).and_return("generated XML")
        get :index
        response.body.should == "generated XML"
      end
    
    end

  end

  describe "responding to GET show" do

    it "should expose the requested instance as @instance" do
      @account_instances.should_receive(:find).with("37").and_return(mock_instance)
      get :show, :id => "37"
      assigns[:instance].should equal(mock_instance)
    end
    
    describe "with mime type of xml" do

      it "should render the requested instance as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        @account_instances.should_receive(:find).with("37").and_return(mock_instance)
        mock_instance.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37"
        response.body.should == "generated XML"
      end

    end
    
  end

  describe "responding to GET new" do

    before do
      @account_instances.stub!(:new).and_return(mock_instance)

      @current_user.account.stub_method_chain 'images.machines.available.for_select', ['account_machines']
      @current_user.account.stub_method_chain 'availability_zones.available.for_select', ['availability_zones']
      @current_user.account.stub_method_chain 'security_groups.for_select', ['security_groups']
      @current_user.account.stub_method_chain 'key_pairs.for_select', ['key_pairs']

      Image.stub_method_chain 'machines.available.are_public.for_select', ['all_machines']
      Image.stub_method_chain 'kernels.available.are_public.for_select', ['kernels']
      Image.stub_method_chain 'ramdisks.available.are_public.for_select', ['ramdisks']

      get :new
    end

    it "should expose a new instance as @instance" do
      assigns[:instance].should equal(mock_instance)
    end

    it "should expose an array of items as @account_machines" do
      assigns[:account_machines].should == ['account_machines']
    end

    it "should expose an array of items as @all_machines" do
      assigns[:all_machines].should == ['all_machines']
    end

    it "should expose an array of items as @kernels" do
      assigns[:kernels].should == ['kernels']
    end

    it "should expose an array of items as @ramdisks" do
      assigns[:ramdisks].should == ['ramdisks']
    end

    it "should expose an array of items as @availability_zones" do
      assigns[:availability_zones].should == ['availability_zones']
    end

    it "should expose an array of items as @security_groups" do
      assigns[:security_groups].should == ['security_groups']
    end

    it "should expose an array of items as @key_pairs" do
      assigns[:key_pairs].should == ['key_pairs']
    end

  end

  describe "responding to GET edit" do
  
    it "should expose the requested instance as @instance" do
      @account_instances.should_receive(:find).with("37").and_return(mock_instance)
      get :edit, :id => "37"
      assigns[:instance].should equal(mock_instance)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do
      
      it "should expose a newly created instance as @instance" do
        @account_instances.should_receive(:new).with({'these' => 'params'}).and_return(mock_instance(:save => true))
        post :create, :instance => {:these => 'params'}
        assigns(:instance).should equal(mock_instance)
      end

      it "should redirect to the created instance" do
        @account_instances.stub!(:new).and_return(mock_instance(:save => true))
        post :create, :instance => {}
        response.should redirect_to(instance_url(mock_instance))
      end
      
    end
    
    describe "with invalid params" do

      it "should expose a newly created but unsaved instance as @instance" do
        @account_instances.stub!(:new).with({'these' => 'params'}).and_return(mock_instance(:save => false))
        post :create, :instance => {:these => 'params'}
        assigns(:instance).should equal(mock_instance)
      end

      it "should re-render the 'new' template" do
        @account_instances.stub!(:new).and_return(mock_instance(:save => false))
        post :create, :instance => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to PUT udpate" do

    describe "with valid params" do

      it "should update the requested instance" do
        @account_instances.should_receive(:find).with("37").and_return(mock_instance)
        mock_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :instance => {:these => 'params'}
      end

      it "should expose the requested instance as @instance" do
        @account_instances.stub!(:find).and_return(mock_instance(:update_attributes => true))
        put :update, :id => "1"
        assigns(:instance).should equal(mock_instance)
      end

      it "should redirect to the instance" do
        @account_instances.stub!(:find).and_return(mock_instance(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(instance_url(mock_instance))
      end

    end
    
    describe "with invalid params" do

      it "should update the requested instance" do
        @account_instances.should_receive(:find).with("37").and_return(mock_instance)
        mock_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :instance => {:these => 'params'}
      end

      it "should expose the instance as @instance" do
        @account_instances.stub!(:find).and_return(mock_instance(:update_attributes => false))
        put :update, :id => "1"
        assigns(:instance).should equal(mock_instance)
      end

      it "should re-render the 'edit' template" do
        @account_instances.stub!(:find).and_return(mock_instance(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested instance" do
      @account_instances.should_receive(:find).with("37").and_return(mock_instance)
      mock_instance.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "should redirect to the instances list" do
      @account_instances.stub!(:find).and_return(mock_instance(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(instances_url)
    end

  end

end
