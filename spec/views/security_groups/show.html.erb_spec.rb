require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/security_groups/show.html.erb" do
  include SecurityGroupsHelper
  
  before(:each) do
    assigns[:security_group] = @security_group = stub_model(SecurityGroup,
      :aws_group_name => "value for aws_group_name",
      :aws_description => "value for aws_description",
      :aws_perms => "value for aws_perms"
    )
  end

  it "should render attributes in <p>" do
    render "/security_groups/show.html.erb"
    response.should have_text(/value\ for\ aws_group_name/)
    response.should have_text(/value\ for\ aws_description/)
    response.should have_text(/value\ for\ aws_perms/)
  end
end

