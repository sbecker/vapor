require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/addresses/show.html.erb" do
  include AddressesHelper
  
  before(:each) do
    assigns[:address] = @address = stub_model(Address,
      :public_ip => "value for public_ip"
    )
  end

  it "should render attributes in <p>" do
    render "/addresses/show.html.erb"
    response.should have_text(/value\ for\ public_ip/)
  end
end

