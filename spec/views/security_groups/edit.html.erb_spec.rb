require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/security_groups/edit.html.erb" do
  include SecurityGroupsHelper
  
  before(:each) do
    assigns[:security_group] = @security_group = stub_model(SecurityGroup,
      :new_record? => false,
      :name => "value for name",
      :description => "value for description",
      :permissions => "value for permissions"
    )
  end

  it "should render edit form" do
    render "/security_groups/edit.html.erb"
    
    response.should have_tag("form[action=#{security_group_path(@security_group)}][method=post]") do
      with_tag('input#security_group_name[name=?]', "security_group[name]")
      with_tag('input#security_group_description[name=?]', "security_group[description]")
      with_tag('textarea#security_group_permissions[name=?]', "security_group[permissions]")
    end
  end
end


