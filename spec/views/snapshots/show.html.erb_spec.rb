require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/snapshots/show.html.erb" do
  include SnapshotsHelper

  before(:each) do
    assigns[:snapshot] = @snapshot = stub_model(Snapshot,
      :aws_progress => "value for aws_progress",
      :aws_status   => "value for aws_status"
    )
  end

  it "should render attributes in <p>" do
    render "/snapshots/show.html.erb"
    response.should have_text(/value\ for\ aws_progress/)
    response.should have_text(/value\ for\ aws_status/)
  end
end

