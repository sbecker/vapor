require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/instances/index.html.erb" do
  include InstancesHelper
  
  before(:each) do
    assigns[:instances] = [
      stub_model(Instance,
        :ami_launch_index      => "1",
        :aws_availability_zone => "value for aws_availability_zone",
        :aws_groups            => ["default", "special"],
        :aws_instance_type     => "value for aws_instance_type",
        :aws_launch_time       => "2007-06-22 00:21:44",
        :aws_owner             => "value for aws_owner",
        :aws_product_codes     => ["product_code1", "product_code2"],
        :aws_reason            => "value for aws_reason",
        :aws_state             => "value for aws_state",
        :aws_state_code        => "value for aws_state_code",
        :dns_name              => "value for dns_name",
        :private_dns_name      => "value for private_dns_name",
        :ssh_key_name          => "value for ssh_key_name"
      ),
      stub_model(Instance,
        :ami_launch_index      => "1",
        :aws_availability_zone => "value for aws_availability_zone",
        :aws_groups            => ["default", "special"],
        :aws_instance_type     => "value for aws_instance_type",
        :aws_launch_time       => "2007-06-22 00:21:44",
        :aws_owner             => "value for aws_owner",
        :aws_product_codes     => ["product_code1", "product_code2"],
        :aws_reason            => "value for aws_reason",
        :aws_state             => "value for aws_state",
        :aws_state_code        => "value for aws_state_code",
        :dns_name              => "value for dns_name",
        :private_dns_name      => "value for private_dns_name",
        :ssh_key_name          => "value for ssh_key_name"
      )
    ]
  end

  it "should render list of instances" do
    render "/instances/index.html.erb"
    response.should have_tag("tr>td", "value for aws_availability_zone", 2)
    response.should have_tag("tr>td", "default, special", 2)
    response.should have_tag("tr>td", "value for aws_instance_type", 2)
    response.should have_tag("tr>td", "June 22, 2007 00:21", 2)
    response.should have_tag("tr>td", "value for aws_owner", 2)
    response.should have_tag("tr>td", "product_code1, product_code2", 2)
    response.should have_tag("tr>td", "value for aws_reason", 2)
    response.should have_tag("tr>td", "value for aws_state", 2)
    response.should have_tag("tr>td", "value for aws_state_code", 2)
    response.should have_tag("tr>td", "value for dns_name", 2)
    response.should have_tag("tr>td", "value for private_dns_name", 2)
    response.should have_tag("tr>td", "value for ssh_key_name", 2)
  end
end

