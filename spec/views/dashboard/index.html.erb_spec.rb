require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/dashboard/index" do
  before(:each) do
    assigns[:ec2_stats] = {:image_count => 1, :key_pair_count => 2, :security_group_count => 3}
    render 'dashboard/index'
  end

  it "should have a heading for 'Dashboard'" do
    response.should have_tag('h2', %r[Dashboard])
  end

  describe "EC2 Stats for current account" do

    it "should list number of images" do
      response.should have_tag('li', %r[Images: 1])
    end

    it "should list number of key pairs" do
      response.should have_tag('li', %r[Key Pairs: 2])
    end

    it "should list number of security groups" do
      response.should have_tag('li', %r[Security Groups: 3])
    end

  end

end
