require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe VolumesController do

  before do
    stub_logged_in
    @account_volumes = mock("Volume")
    @current_account.stub!(:volumes => @account_volumes)
  end

  def mock_volume(stubs={})
    @mock_volume ||= mock_model(Volume, stubs)
  end

  describe "responding to GET index" do

    it "should expose all volumes as @volumes" do
      @account_volumes.should_receive(:all).and_return([mock_volume])
      get :index
      assigns[:volumes].should == [mock_volume]
    end

    describe "with mime type of xml" do

      it "should render all volumes as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        @account_volumes.should_receive(:all).and_return(volumes = mock("Array of Volumes"))
        volumes.should_receive(:to_xml).and_return("generated XML")
        get :index
        response.body.should == "generated XML"
      end

    end

  end

  describe "responding to GET show" do

    it "should expose the requested volume as @volume" do
      @account_volumes.should_receive(:find).with("37").and_return(mock_volume)
      get :show, :id => "37"
      assigns[:volume].should equal(mock_volume)
    end

    describe "with mime type of xml" do

      it "should render the requested volume as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        @account_volumes.should_receive(:find).with("37").and_return(mock_volume)
        mock_volume.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37"
        response.body.should == "generated XML"
      end

    end

  end

  describe "responding to GET new" do

    before do
      @account_volumes.stub!(:new).and_return(mock_volume)
      @current_account.stub_method_chain 'availability_zones.available.for_select', ['availability_zones']
      get :new
    end

    it "should expose a new volume as @volume" do
      assigns[:volume].should equal(mock_volume)
    end

    it "should expose a new volume as @volume" do
      assigns[:availability_zones].should == ['availability_zones']
    end

  end

  describe "responding to GET edit" do

    it "should expose the requested volume as @volume" do
      @account_volumes.should_receive(:find).with("37").and_return(mock_volume)
      get :edit, :id => "37"
      assigns[:volume].should equal(mock_volume)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do

      it "should expose a newly created volume as @volume" do
        @account_volumes.should_receive(:new).with({'these' => 'params'}).and_return(mock_volume(:save => true))
        post :create, :volume => {:these => 'params'}
        assigns(:volume).should equal(mock_volume)
      end

      it "should redirect to the created volume" do
        @account_volumes.stub!(:new).and_return(mock_volume(:save => true))
        post :create, :volume => {}
        response.should redirect_to(volume_url(mock_volume))
      end

    end

    describe "with invalid params" do

      it "should expose a newly created but unsaved volume as @volume" do
        @account_volumes.stub!(:new).with({'these' => 'params'}).and_return(mock_volume(:save => false))
        post :create, :volume => {:these => 'params'}
        assigns(:volume).should equal(mock_volume)
      end

      it "should re-render the 'new' template" do
        @account_volumes.stub!(:new).and_return(mock_volume(:save => false))
        post :create, :volume => {}
        response.should render_template('new')
      end

    end

  end

  describe "responding to PUT udpate" do

    describe "with valid params" do

      it "should update the requested volume" do
        @account_volumes.should_receive(:find).with("37").and_return(mock_volume)
        mock_volume.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :volume => {:these => 'params'}
      end

      it "should expose the requested volume as @volume" do
        @account_volumes.stub!(:find).and_return(mock_volume(:update_attributes => true))
        put :update, :id => "1"
        assigns(:volume).should equal(mock_volume)
      end

      it "should redirect to the volume" do
        @account_volumes.stub!(:find).and_return(mock_volume(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(volume_url(mock_volume))
      end

    end

    describe "with invalid params" do

      it "should update the requested volume" do
        @account_volumes.should_receive(:find).with("37").and_return(mock_volume)
        mock_volume.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :volume => {:these => 'params'}
      end

      it "should expose the volume as @volume" do
        @account_volumes.stub!(:find).and_return(mock_volume(:update_attributes => false))
        put :update, :id => "1"
        assigns(:volume).should equal(mock_volume)
      end

      it "should re-render the 'edit' template" do
        @account_volumes.stub!(:find).and_return(mock_volume(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested volume" do
      @account_volumes.should_receive(:find).with("37").and_return(mock_volume)
      mock_volume.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "should redirect to the volumes list" do
      @account_volumes.stub!(:find).and_return(mock_volume(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(volumes_url)
    end

  end

end
