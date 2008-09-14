require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/addresses/edit.html.erb" do
  include AddressesHelper
  
  before(:each) do
    assigns[:address] = @address = stub_model(Address,
      :new_record? => false,
      :public_ip => "value for public_ip"
    )
  end

  it "should render edit form" do
    render "/addresses/edit.html.erb"
    
    response.should have_tag("form[action=#{address_path(@address)}][method=post]") do
      with_tag('input#address_public_ip[name=?]', "address[public_ip]")
    end
  end
end


