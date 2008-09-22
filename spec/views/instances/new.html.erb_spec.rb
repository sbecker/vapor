require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/instances/new.html.erb" do
  include InstancesHelper

  before(:each) do
    assigns[:instance] = stub_model(Instance,
      :new_record?           => true,
      :aws_image_id          => "value for aws_image_id",
      :aws_kernel_id         => "value for aws_kernel_id",
      :aws_kernel_id         => "value for aws_availability_zone",
      :ssh_key_name          => "value for ssh_key_name",
      :aws_groups            => "value for aws_groups",
      :aws_instance_type     => "value for aws_instance_type",
      :aws_availability_zone => "value for aws_availability_zone"
    )

    assigns[:account_machines]   = [stub_model(Image, :aws_location_short => 'foo', :aws_id => "1")]
    assigns[:all_machines]       = [stub_model(Image, :aws_location_short => 'foo', :aws_id => "1")]
    assigns[:kernels]            = [stub_model(Image, :aws_location_short => 'foo', :aws_id => "1")]
    assigns[:ramdisks]           = [stub_model(Image, :aws_location_short => 'foo', :aws_id => "1")]
    assigns[:key_pairs]          = [stub_model(KeyPair, :aws_key_name => 'foo')]
    assigns[:security_groups]    = [stub_model(SecurityGroup, :aws_group_name => 'foo')]
    assigns[:availability_zones] = [stub_model(AvailabilityZone, :zone_name => 'foo')]
  end

  it "should render new form" do
    render "/instances/new.html.erb"

    response.should have_tag("form[action=?][method=post]", instances_path) do
      with_tag("select#instance_aws_image_id[name=?]",          "instance[aws_image_id]")
      with_tag("select#instance_aws_kernel_id[name=?]",         "instance[aws_kernel_id]")
      with_tag("select#instance_aws_ramdisk_id[name=?]",        "instance[aws_ramdisk_id]")
      with_tag("select#instance_ssh_key_name[name=?]",          "instance[ssh_key_name]")
      with_tag("select#instance_aws_groups[name=?]",            "instance[aws_groups][]")
      with_tag("select#instance_aws_instance_type[name=?]",     "instance[aws_instance_type]")
      with_tag("select#instance_aws_availability_zone[name=?]", "instance[aws_availability_zone]")
    end
  end
end
