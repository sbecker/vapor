require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/addresses/index.html.erb" do
  include AddressesHelper
  
  before(:each) do
    assigns[:addresses] = [
      stub_model(Address,
        :instance_id => "value for instance_id",
        :public_ip   => "value for public_ip"
      ),
      stub_model(Address,
        :instance_id => "value for instance_id",
        :public_ip   => "value for public_ip"
      )
    ]
  end

  it "should render list of addresses" do
    render "/addresses/index.html.erb"
    response.should have_tag("tr>td", "value for instance_id", 2)
    response.should have_tag("tr>td", "value for public_ip", 2)
  end
end

