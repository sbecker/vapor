require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/snapshots/new.html.erb" do
  include SnapshotsHelper

  before(:each) do
    assigns[:snapshot] = stub_model(Snapshot,
      :new_record?   => true,
      :aws_volume_id => "value for aws_volume_id"
    )
  end

  it "should render new form" do
    render "/snapshots/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", snapshots_path) do
      with_tag("input#snapshot_aws_volume_id[name=?]", "snapshot[aws_volume_id]")
    end
  end
end


