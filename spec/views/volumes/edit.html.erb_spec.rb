require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/volumes/edit.html.erb" do
  include VolumesHelper

  before(:each) do
    assigns[:volume] = @volume = stub_model(Volume,
      :new_record?           => false,
      :aws_attachment_status => "value for aws_attachment_status",
      :aws_device            => "value for aws_device",
      :aws_size              => "1",
      :aws_status            => "value for aws_status",
      :zone                  => "value for zone"
    )
  end

  it "should render edit form" do
    render "/volumes/edit.html.erb"
    
    response.should have_tag("form[action=#{volume_path(@volume)}][method=post]") do
      with_tag('input#volume_aws_attachment_status[name=?]', "volume[aws_attachment_status]")
      with_tag('input#volume_aws_device[name=?]', "volume[aws_device]")
      with_tag('input#volume_aws_size[name=?]', "volume[aws_size]")
      with_tag('input#volume_aws_status[name=?]', "volume[aws_status]")
      with_tag('input#volume_zone[name=?]', "volume[zone]")
    end
  end
end


