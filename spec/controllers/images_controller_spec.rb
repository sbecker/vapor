require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ImagesController do
  before do
    mock_logged_in
    @user_images = mock("Image")
    @current_user.stub!(:images).and_return(@user_images)
  end

  def mock_image(stubs={})
    @mock_image ||= mock_model(Image, stubs)
  end
  
  describe "responding to GET index" do

    it "should expose all images as @images" do
      @user_images.should_receive(:all).and_return([mock_image])
      get :index
      assigns[:images].should == [mock_image]
    end

    describe "with mime type of xml" do
  
      it "should render all images as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        @user_images.should_receive(:all).and_return(images = mock("Array of Images"))
        images.should_receive(:to_xml).and_return("generated XML")
        get :index
        response.body.should == "generated XML"
      end
    
    end

  end

  describe "responding to POST sync" do
    before do
      @account = mock_model(Account)
      @current_user.stub!(:account).and_return(@account)
      Image.stub!(:sync_ec2_for_account)
    end

    it "should call sync_ec2_for_account" do
      Image.should_receive(:sync_ec2_for_account).with(@account)
      post :sync
    end

    it "should redirect to index" do
      post :sync
      response.should redirect_to(images_path)
    end
  end

  describe "responding to GET show" do

    it "should expose the requested image as @image" do
      @user_images.should_receive(:find).with("37").and_return(mock_image)
      get :show, :id => "37"
      assigns[:image].should equal(mock_image)
    end
    
    describe "with mime type of xml" do

      it "should render the requested image as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        @user_images.should_receive(:find).with("37").and_return(mock_image)
        mock_image.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37"
        response.body.should == "generated XML"
      end

    end
    
  end

  describe "responding to GET edit" do
  
    it "should expose the requested image as @image" do
      @user_images.should_receive(:find).with("37").and_return(mock_image)
      get :edit, :id => "37"
      assigns[:image].should equal(mock_image)
    end

  end

  describe "responding to PUT update" do

    describe "with valid params" do

      it "should update the requested image" do
        @user_images.should_receive(:find).with("37").and_return(mock_image)
        mock_image.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :image => {:these => 'params'}
      end

      it "should expose the requested image as @image" do
        @user_images.stub!(:find).and_return(mock_image(:update_attributes => true))
        put :update, :id => "1"
        assigns(:image).should equal(mock_image)
      end

      it "should redirect to the image" do
        @user_images.stub!(:find).and_return(mock_image(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(image_path(mock_image))
      end

    end
    
    describe "with invalid params" do

      it "should update the requested image" do
        @user_images.should_receive(:find).with("37").and_return(mock_image)
        mock_image.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :image => {:these => 'params'}
      end

      it "should expose the image as @image" do
        @user_images.stub!(:find).and_return(mock_image(:update_attributes => false))
        put :update, :id => "1"
        assigns(:image).should equal(mock_image)
      end

      it "should re-render the 'edit' template" do
        @user_images.stub!(:find).and_return(mock_image(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

end
