require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/key_pairs/index.html.erb" do
  include KeyPairsHelper
  
  before(:each) do
    assigns[:key_pairs] = [
      stub_model(KeyPair,
        :name => "value for name",
        :fingerprint => "value for fingerprint",
        :private_key => "value for private_key"
      ),
      stub_model(KeyPair,
        :name => "value for name",
        :fingerprint => "value for fingerprint",
        :private_key => "value for private_key"
      )
    ]
    render "/key_pairs/index.html.erb"
  end

  it "should render list of key_pairs" do
    response.should have_tag("tr>td", "value for name", 2)
  end
end

