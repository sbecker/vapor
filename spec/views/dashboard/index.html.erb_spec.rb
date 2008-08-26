require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/dashboard/index" do
  before(:each) do
    assigns[:ec2_stats] = {:image_count => 1}
    render 'dashboard/index'
  end

  it "should have a heading for 'Dashboard'" do
    response.should have_tag('h2', %r[Dashboard])
  end

  describe "EC2 Stats" do

    it "should list the user's current number of images" do
      response.should have_tag('li', %r[Images: 1])
    end

  end

end
