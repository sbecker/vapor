require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/volumes/edit.html.erb" do
  include VolumesHelper

  before(:each) do
    assigns[:volume] = @volume = stub_model(Volume,
      :new_record?           => false,
      :aws_attached_at       => "2007-06-23 00:21:44",
      :aws_attachment_status => "value for aws_attachment_status",
      :aws_created_at        => "2007-06-22 00:21:44",
      :aws_device            => "value for aws_device",
      :aws_instance_id       => "value for aws_instance_id",
      :aws_size              => "1",
      :aws_status            => "value for aws_status",
      :zone                  => "value for zone"
    )
  end

  it "should render edit form" do
    render "/volumes/edit.html.erb"
    
    response.should have_tag("form[action=#{volume_path(@volume)}][method=post]") do
      with_tag('input#volume_aws_device[name=?]', "volume[aws_device]")
      with_tag('input#volume_aws_instance_id[name=?]', "volume[aws_instance_id]")
    end
  end
end


