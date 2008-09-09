require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SecurityGroupsHelper do
  include SecurityGroupsHelper

  it "should format permissions " do
    format_permissions([
      {:owner => "owner", :group => "group"},
      {:protocol => "tcp", :cidr_ips => "0.0.0.0/0", :from_port => "22", :to_port => "80"},
    ]).should == "Group: group, Owner: owner<br />Protocol: tcp, CIDR IP: 0.0.0.0/0, From Port: 22, To Port: 80<br />"
  end

end
