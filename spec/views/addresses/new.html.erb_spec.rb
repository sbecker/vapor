require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/addresses/new.html.erb" do
  include AddressesHelper
  
  before(:each) do
    assigns[:address] = stub_model(Address,
      :new_record? => true,
      :public_ip => "value for public_ip"
    )
  end

  it "should render new form" do
    render "/addresses/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", addresses_path) do
      with_tag("input#address_public_ip[name=?]", "address[public_ip]")
    end
  end
end


