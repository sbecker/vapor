require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/security_groups/new.html.erb" do
  include SecurityGroupsHelper
  
  before(:each) do
    assigns[:security_group] = stub_model(SecurityGroup,
      :new_record? => true,
      :aws_group_name => "value for aws_group_name",
      :aws_description => "value for aws_description",
      :aws_perms => "value for aws_perms"
    )
  end

  it "should render new form" do
    render "/security_groups/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", security_groups_path) do
      with_tag("input#security_group_aws_group_name[name=?]", "security_group[aws_group_name]")
      with_tag("input#security_group_aws_description[name=?]", "security_group[aws_description]")
      with_tag("textarea#security_group_aws_perms[name=?]", "security_group[aws_perms]")
    end
  end
end


