require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/security_groups/index.html.erb" do
  include SecurityGroupsHelper
  
  before(:each) do
    assigns[:security_groups] = [
      stub_model(SecurityGroup,
        :aws_group_name  => "value for aws_group_name",
        :aws_description => "value for aws_description",
        :aws_perms       => [{:owner => "owner", :group => "group"}]
      ),
      stub_model(SecurityGroup,
        :aws_group_name  => "value for aws_group_name",
        :aws_description => "value for aws_description",
        :aws_perms       => [{:owner => "owner", :group => "group"}]
      )
    ]
  end

  it "should render list of security_groups" do
    render "/security_groups/index.html.erb"
    response.should have_tag("tr>td", "value for aws_group_name", 2)
    response.should have_tag("tr>td", "value for aws_description", 2)
    response.should have_tag("tr>td", "Group: group, Owner: owner", 2)
  end

end

