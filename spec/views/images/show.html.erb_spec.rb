require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/images/show.html.erb" do
  include ImagesHelper

  before(:each) do
    assigns[:image] = @image = stub_model(Image,
      :aws_architecture => "value for architecture",
      :aws_is_public    => false,
      :aws_location     => "value for location",
      :aws_state        => "value for state",
      :aws_image_type   => "value for image_type",
      :description      => "value for description",
      :name             => "value for name"
    )
  end

  it "should render attributes in <p>" do
    render "/images/show.html.erb"
    response.should have_text(/value\ for\ architecture/)
    response.should have_text(/false/)
    response.should have_text(/value\ for\ location/)
    response.should have_text(/value\ for\ state/)
    response.should have_text(/value\ for\ image_type/)
    response.should have_text(/value\ for\ description/)
    response.should have_text(/value\ for\ name/)
  end
end

