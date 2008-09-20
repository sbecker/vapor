require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/snapshots/new.html.erb" do
  include SnapshotsHelper

  before(:each) do
    assigns[:snapshot] = stub_model(Snapshot,
      :new_record?  => true,
      :aws_progress => "value for aws_progress",
      :aws_status   => "value for aws_status"
    )
  end

  it "should render new form" do
    render "/snapshots/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", snapshots_path) do
      with_tag("input#snapshot_aws_progress[name=?]", "snapshot[aws_progress]")
      with_tag("input#snapshot_aws_status[name=?]", "snapshot[aws_status]")
    end
  end
end


