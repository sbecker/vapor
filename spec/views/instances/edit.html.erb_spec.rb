require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/instances/edit.html.erb" do
  include InstancesHelper
  
  before(:each) do
    assigns[:instance] = @instance = stub_model(Instance,
      :new_record?           => false,
      :ami_launch_index      => "1",
      :aws_availability_zone => "value for aws_availability_zone",
      :aws_groups            => ["default", "special"],
      :aws_instance_type     => "value for aws_instance_type",
      :aws_launch_time       => "2007-06-22 00:21:44",
      :aws_owner             => "value for aws_owner",
      :aws_product_codes     => ["default", "special"],
      :aws_reason            => "value for aws_reason",
      :aws_state             => "value for aws_state",
      :aws_state_code        => "value for aws_state_code",
      :dns_name              => "value for dns_name",
      :private_dns_name      => "value for private_dns_name",
      :ssh_key_name          => "value for ssh_key_name"
    )
  end

  it "should render edit form" do
    render "/instances/edit.html.erb"
    
    response.should have_tag("form[action=#{instance_path(@instance)}][method=post]") do
      # TODO - add name and description attributes and make them editable
      # with_tag('input#instance_name[name=?]', "instance[name]")
      # with_tag('input#instance_description[name=?]', "instance[description]")
    end
  end
end


