require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/volumes/index.html.erb" do
  include VolumesHelper
  
  before(:each) do
    assigns[:volumes] = [
      stub_model(Volume,
        :aws_attachment_status => "value for aws_attachment_status",
        :aws_created_at        => "2007-06-22 00:21:44",
        :aws_device            => "value for aws_device",
        :aws_size              => "1",
        :aws_status            => "value for aws_status",
        :zone                  => "value for zone"
      ),
      stub_model(Volume,
        :aws_attachment_status => "value for aws_attachment_status",
        :aws_created_at        => "2007-06-22 00:21:44",
        :aws_device            => "value for aws_device",
        :aws_size              => "1",
        :aws_status            => "value for aws_status",
        :zone                  => "value for zone"
      )
    ]
  end

  it "should render list of volumes" do
    render "/volumes/index.html.erb"
    response.should have_tag("tr>td", "value for aws_attachment_status", 2)
    response.should have_tag("tr>td", "June 22, 2007 00:21", 2)
    response.should have_tag("tr>td", "value for aws_device", 2)
    response.should have_tag("tr>td", "1 GB", 2)
    response.should have_tag("tr>td", "value for aws_status", 2)
    response.should have_tag("tr>td", "value for zone", 2)
  end
end

