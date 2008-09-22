require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe InstancesHelper do
  include InstancesHelper

  describe "aws instance types" do
    it "should return an array of AWS instance types" do
      aws_instance_types.should == %w(m1.small m1.large m1.xlarge c1.medium c1.xlarge)
    end
  end

end
