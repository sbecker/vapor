require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SnapshotsController do

  before do
    stub_logged_in
    @account_snapshots = mock('Snapshot')
    @current_account.stub!(:snapshots => @account_snapshots)
  end

  def mock_snapshot(stubs={})
    @mock_snapshot ||= mock_model(Snapshot, stubs)
  end
  
  describe "responding to GET index" do

    it "should expose all snapshots as @snapshots" do
      @account_snapshots.should_receive(:all).and_return([mock_snapshot])
      get :index
      assigns[:snapshots].should == [mock_snapshot]
    end

    describe "with mime type of xml" do
  
      it "should render all snapshots as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        @account_snapshots.should_receive(:all).and_return(snapshots = mock("Array of Snapshots"))
        snapshots.should_receive(:to_xml).and_return("generated XML")
        get :index
        response.body.should == "generated XML"
      end
    
    end

  end

  describe "responding to GET show" do

    it "should expose the requested snapshot as @snapshot" do
      @account_snapshots.should_receive(:find).with("37").and_return(mock_snapshot)
      get :show, :id => "37"
      assigns[:snapshot].should equal(mock_snapshot)
    end
    
    describe "with mime type of xml" do

      it "should render the requested snapshot as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        @account_snapshots.should_receive(:find).with("37").and_return(mock_snapshot)
        mock_snapshot.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37"
        response.body.should == "generated XML"
      end

    end
    
  end

  describe "responding to GET new" do

    before do
      @account_snapshots.stub!(:new => mock_snapshot)
      @current_account.stub!(:volumes => ['volumes'])
      get :new
    end

    it "should expose a new snapshot as @snapshot" do
      assigns[:snapshot].should equal(mock_snapshot)
    end

    it "should expose an array of volumes as @volumes" do
      assigns[:volumes].should == ['volumes']
    end

  end

  describe "responding to GET edit" do
  
    it "should expose the requested snapshot as @snapshot" do
      @account_snapshots.should_receive(:find).with("37").and_return(mock_snapshot)
      get :edit, :id => "37"
      assigns[:snapshot].should equal(mock_snapshot)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do
      
      it "should expose a newly created snapshot as @snapshot" do
        @account_snapshots.should_receive(:new).with({'these' => 'params'}).and_return(mock_snapshot(:save => true))
        post :create, :snapshot => {:these => 'params'}
        assigns(:snapshot).should equal(mock_snapshot)
      end

      it "should redirect to the created snapshot" do
        @account_snapshots.stub!(:new).and_return(mock_snapshot(:save => true))
        post :create, :snapshot => {}
        response.should redirect_to(snapshot_url(mock_snapshot))
      end
      
    end
    
    describe "with invalid params" do

      it "should expose a newly created but unsaved snapshot as @snapshot" do
        @account_snapshots.stub!(:new).with({'these' => 'params'}).and_return(mock_snapshot(:save => false))
        post :create, :snapshot => {:these => 'params'}
        assigns(:snapshot).should equal(mock_snapshot)
      end

      it "should re-render the 'new' template" do
        @account_snapshots.stub!(:new).and_return(mock_snapshot(:save => false))
        post :create, :snapshot => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to PUT udpate" do

    describe "with valid params" do

      it "should update the requested snapshot" do
        @account_snapshots.should_receive(:find).with("37").and_return(mock_snapshot)
        mock_snapshot.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :snapshot => {:these => 'params'}
      end

      it "should expose the requested snapshot as @snapshot" do
        @account_snapshots.stub!(:find).and_return(mock_snapshot(:update_attributes => true))
        put :update, :id => "1"
        assigns(:snapshot).should equal(mock_snapshot)
      end

      it "should redirect to the snapshot" do
        @account_snapshots.stub!(:find).and_return(mock_snapshot(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(snapshot_url(mock_snapshot))
      end

    end
    
    describe "with invalid params" do

      it "should update the requested snapshot" do
        @account_snapshots.should_receive(:find).with("37").and_return(mock_snapshot)
        mock_snapshot.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :snapshot => {:these => 'params'}
      end

      it "should expose the snapshot as @snapshot" do
        @account_snapshots.stub!(:find).and_return(mock_snapshot(:update_attributes => false))
        put :update, :id => "1"
        assigns(:snapshot).should equal(mock_snapshot)
      end

      it "should re-render the 'edit' template" do
        @account_snapshots.stub!(:find).and_return(mock_snapshot(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested snapshot" do
      @account_snapshots.should_receive(:find).with("37").and_return(mock_snapshot)
      mock_snapshot.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "should redirect to the snapshots list" do
      @account_snapshots.stub!(:find).and_return(mock_snapshot(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(snapshots_url)
    end

  end

end
