require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/security_groups/index.html.erb" do
  include SecurityGroupsHelper
  
  before(:each) do
    assigns[:security_groups] = [
      stub_model(SecurityGroup,
        :name => "value for name",
        :description => "value for description",
        :permissions => [{:owner => "owner", :group => "group"}]
      ),
      stub_model(SecurityGroup,
        :name => "value for name",
        :description => "value for description",
        :permissions => [{:owner => "owner", :group => "group"}]
      )
    ]
  end

  it "should render list of security_groups" do
    render "/security_groups/index.html.erb"
    response.should have_tag("tr>td", "value for name", 2)
    response.should have_tag("tr>td", "value for description", 2)
    response.should have_tag("tr>td", "Group: group, Owner: owner", 2)
  end

end

