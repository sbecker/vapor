require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/images/edit.html.erb" do
  include ImagesHelper
  
  before(:each) do
    @image = mock_model(Image,
      :new_record?      => false,
      :aws_architecture => "value for aws architecture",
      :aws_id           => "value for aws id",
      :aws_image_type   => "value for aws image type",
      :aws_is_public    => false,
      :aws_location     => "value for aws location",
      :aws_owner        => "value for aws owner",
      :aws_state        => "value for aws state",
      :description      => "value for description",
      :name             => "value for name"
    )
    assigns[:image] = @image
  end

  it "should render edit form" do
    render "/images/edit.html.erb"
    
    response.should have_tag("form[action=#{image_path(@image)}][method=post]") do
      with_tag('input#image_name[name=?]', "image[name]")
      with_tag('textarea#image_description[name=?]', "image[description]")
    end

    response.should have_text(/value\ for\ aws\ architecture/)
    response.should have_text(/als/)
    response.should have_text(/value\ for\ aws\ location/)
    response.should have_text(/value\ for\ aws\ state/)
    response.should have_text(/value\ for\ aws\ image\ type/)
    response.should have_text(/value\ for\ aws\ id/)
    response.should have_text(/value\ for\ aws\ owner/)
  end
end

