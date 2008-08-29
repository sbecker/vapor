require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/key_pairs/show.html.erb" do
  include KeyPairsHelper
  
  before(:each) do
    assigns[:key_pair] = @key_pair = stub_model(KeyPair,
      :name => "value for name",
      :fingerprint => "value for fingerprint",
      :private_key => "value for private_key"
    )
  end

  it "should render attributes in <p>" do
    render "/key_pairs/show.html.erb"
    response.should have_text(/value\ for\ name/)
    response.should have_text(/value\ for\ fingerprint/)
    response.should have_text(/value\ for\ private_key/)
  end
end

