require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/instances/show.html.erb" do
  include InstancesHelper
  
  before(:each) do
    assigns[:instance] = @instance = stub_model(Instance,
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
  end

  it "should render attributes in <p>" do
    render "/instances/show.html.erb"
    response.should have_text(/1/)
    response.should have_text(/value\ for\ aws_availability_zone/)
    response.should have_text(/default,\ special/)
    response.should have_text(/value\ for\ aws_instance_type/)
    response.should have_text(/value\ for\ aws_owner/)
    response.should have_text(/product_code1,\ product_code2/)
    response.should have_text(/value\ for\ aws_reason/)
    response.should have_text(/value\ for\ aws_state/)
    response.should have_text(/value\ for\ aws_state_code/)
    response.should have_text(/value\ for\ dns_name/)
    response.should have_text(/value\ for\ private_dns_name/)
    response.should have_text(/value\ for\ ssh_key_name/)
  end
end

