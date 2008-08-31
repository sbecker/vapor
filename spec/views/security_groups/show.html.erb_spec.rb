require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/security_groups/show.html.erb" do
  include SecurityGroupsHelper
  
  before(:each) do
    assigns[:security_group] = @security_group = stub_model(SecurityGroup,
      :name => "value for name",
      :description => "value for description",
      :permissions => "value for permissions"
    )
  end

  it "should render attributes in <p>" do
    render "/security_groups/show.html.erb"
    response.should have_text(/value\ for\ name/)
    response.should have_text(/value\ for\ description/)
    response.should have_text(/value\ for\ permissions/)
  end
end

