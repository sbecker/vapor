require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/volumes/new.html.erb" do
  include VolumesHelper

  before(:each) do
    assigns[:volume] = stub_model(Volume,
      :new_record? => true,
      :aws_size    => "1",
      :snapshot_id => "value for snapshot_id",
      :zone        => "value for zone"
    )
  end

  it "should render new form" do
    render "/volumes/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", volumes_path) do
      with_tag("input#volume_aws_size[name=?]", "volume[aws_size]")
      with_tag("input#volume_snapshot_id[name=?]", "volume[snapshot_id]")
      with_tag("input#volume_zone[name=?]", "volume[zone]")
    end
  end
end


