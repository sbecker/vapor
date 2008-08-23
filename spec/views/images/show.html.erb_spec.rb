require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/images/show.html.erb" do
  include ImagesHelper
  
  before(:each) do
    assigns[:image] = @image = stub_model(Image,
      :architecture => "value for architecture",
      :description => "value for description",
      :is_public => false,
      :location => "value for location",
      :name => "value for name",
      :state => "value for state",
      :image_type => "value for image_type"
    )
  end

  it "should render attributes in <p>" do
    render "/images/show.html.erb"
    response.should have_text(/value\ for\ architecture/)
    response.should have_text(/value\ for\ description/)
    response.should have_text(/als/)
    response.should have_text(/value\ for\ location/)
    response.should have_text(/value\ for\ name/)
    response.should have_text(/value\ for\ state/)
    response.should have_text(/value\ for\ image_type/)
  end
end

