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
        :image_type => "value for image_type"
      ),
      stub_model(Image,
        :architecture => "value for architecture",
        :description => "value for description",
        :is_public => false,
        :location => "value for location",
        :name => "value for name",
        :state => "value for state",
        :image_type => "value for image_type"
      )
    ]
  end

  it "should render list of images" do
    render "/images/index.html.erb"

    response.should have_tag('a', 'Amazon')
    response.should have_tag('a', 'Alestic')
    response.should have_tag('a', 'RBuilder')
    response.should have_tag('a', 'RedHat')
    response.should have_tag('a', 'RightScale')
    response.should have_tag('a', 'Scalr')
    response.should have_tag('a', 'Others')

    response.should have_tag("tr>td", "value for architecture", 2)
    response.should have_tag("tr>td", "value for description", 2)
    response.should have_tag("tr>td", "false", 2)
    response.should have_tag("tr>td", "value for location", 2)
    response.should have_tag("tr>td", "value for name", 2)
    response.should have_tag("tr>td", "value for state", 2)
    response.should have_tag("tr>td", "value for image_type", 2)

    response.should have_tag("a", "Sync with EC2")
  end
end

