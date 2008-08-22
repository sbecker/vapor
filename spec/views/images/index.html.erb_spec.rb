require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/images/index.html.erb" do
  include ImagesHelper
  
  before(:each) do
    assigns[:images] = [
      stub_model(Image,
        :architecture => "value for architecture",
        :description => "value for description",
        :is_public => false,
        :location => "value for location",
        :name => "value for name",
        :state => "value for state",
        :type => "value for type"
      ),
      stub_model(Image,
        :architecture => "value for architecture",
        :description => "value for description",
        :is_public => false,
        :location => "value for location",
        :name => "value for name",
        :state => "value for state",
        :type => "value for type"
      )
    ]
  end

  it "should render list of images" do
    render "/images/index.html.erb"
    response.should have_tag("tr>td", "value for architecture", 2)
    response.should have_tag("tr>td", "value for description", 2)
    response.should have_tag("tr>td", "false", 2)
    response.should have_tag("tr>td", "value for location", 2)
    response.should have_tag("tr>td", "value for name", 2)
    response.should have_tag("tr>td", "value for state", 2)
    response.should have_tag("tr>td", "value for type", 2)
  end
end

