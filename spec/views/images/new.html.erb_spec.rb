require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/images/new.html.erb" do
  include ImagesHelper
  
  before(:each) do
    assigns[:image] = stub_model(Image,
      :new_record? => true,
      :architecture => "value for architecture",
      :description => "value for description",
      :is_public => false,
      :location => "value for location",
      :name => "value for name",
      :state => "value for state",
      :type => "value for type"
    )
  end

  it "should render new form" do
    render "/images/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", images_path) do
      with_tag("input#image_architecture[name=?]", "image[architecture]")
      with_tag("textarea#image_description[name=?]", "image[description]")
      with_tag("input#image_is_public[name=?]", "image[is_public]")
      with_tag("input#image_location[name=?]", "image[location]")
      with_tag("input#image_name[name=?]", "image[name]")
      with_tag("input#image_state[name=?]", "image[state]")
      with_tag("input#image_type[name=?]", "image[type]")
    end
  end
end


