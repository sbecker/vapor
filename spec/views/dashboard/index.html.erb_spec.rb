require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/dashboard/index" do
  before(:each) do
    assigns[:ec2_stats] = @ec2_stats = {
      :address_count        => 1,
      :image_count          => 2,
      :instance_count       => 3,
      :key_pair_count       => 4,
      :security_group_count => 5,
      :volume_count         => 6
    }
    render 'dashboard/index'
  end

  it "should have a heading for 'Dashboard'" do
    response.should have_tag('h2', %r[Dashboard])
  end

  describe "EC2 Stats for current account" do

    it "should list number of addresses" do
      response.should have_tag('li', %r[Addresses: #{@ec2_stats[:address_count]}])
    end

    it "should list number of images" do
      response.should have_tag('li', %r[Images: #{@ec2_stats[:image_count]}])
    end

    it "should list number of instances" do
      response.should have_tag('li', %r[Instances: #{@ec2_stats[:instance_count]}])
    end

    it "should list number of key pairs" do
      response.should have_tag('li', %r[Key Pairs: #{@ec2_stats[:key_pair_count]}])
    end

    it "should list number of security groups" do
      response.should have_tag('li', %r[Security Groups: #{@ec2_stats[:security_group_count]}])
    end

    it "should list number of volumes" do
      response.should have_tag('li', %r[Volumes: #{@ec2_stats[:volume_count]}])
    end

  end

end
