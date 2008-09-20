require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/volumes/show.html.erb" do
  include VolumesHelper
  
  before(:each) do
    assigns[:volume] = @volume = stub_model(Volume,
      :aws_attached_at       => "2007-06-23 00:21:44",
      :aws_attachment_status => "value for aws_attachment_status",
      :aws_created_at        => "2007-06-22 00:21:44",
      :aws_device            => "value for aws_device",
      :aws_size              => "1",
      :aws_status            => "value for aws_status",
      :zone                  => "value for zone"
    )
  end

  it "should render attributes in <p>" do
    render "/volumes/show.html.erb"
    response.should have_text(/June\ 23,\ 2007\ 00:21/)
    response.should have_text(/value\ for\ aws_attachment_status/)
    response.should have_text(/June\ 22,\ 2007\ 00:21/)
    response.should have_text(/value\ for\ aws_device/)
    response.should have_text(/1/)
    response.should have_text(/value\ for\ aws_status/)
    response.should have_text(/value\ for\ zone/)
  end
end

