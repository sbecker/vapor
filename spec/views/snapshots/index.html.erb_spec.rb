require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/snapshots/index.html.erb" do
  include SnapshotsHelper

  before(:each) do
    assigns[:snapshots] = [
      stub_model(Snapshot,
        :aws_progress => "value for aws_progress",
        :aws_status   => "value for aws_status"
      ),
      stub_model(Snapshot,
        :aws_progress => "value for aws_progress",
        :aws_status   => "value for aws_status"
      )
    ]
  end

  it "should render list of snapshots" do
    render "/snapshots/index.html.erb"
    response.should have_tag("tr>td", "value for aws_progress", 2)
    response.should have_tag("tr>td", "value for aws_status", 2)
  end
end

