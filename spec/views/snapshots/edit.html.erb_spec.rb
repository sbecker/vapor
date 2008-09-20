require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/snapshots/edit.html.erb" do
  include SnapshotsHelper

  before(:each) do
    assigns[:snapshot] = @snapshot = stub_model(Snapshot,
      :new_record?  => false,
      :aws_progress => "value for aws_progress",
      :aws_status   => "value for aws_status"
    )
  end

  it "should render edit form" do
    render "/snapshots/edit.html.erb"
    
    response.should have_tag("form[action=#{snapshot_path(@snapshot)}][method=post]") do
      with_tag('input#snapshot_aws_progress[name=?]', "snapshot[aws_progress]")
      with_tag('input#snapshot_aws_status[name=?]', "snapshot[aws_status]")
    end
  end
end


