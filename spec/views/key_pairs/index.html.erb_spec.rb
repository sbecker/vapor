require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/key_pairs/index.html.erb" do
  include KeyPairsHelper
  
  before(:each) do
    assigns[:key_pairs] = [
      stub_model(KeyPair,
        :aws_key_name    => "value for aws_key_name",
        :aws_fingerprint => "value for fingerprint",
        :aws_material    => "value for aws_material"
      ),
      stub_model(KeyPair,
        :aws_key_name    => "value for aws_key_name",
        :aws_fingerprint => "value for fingerprint",
        :aws_material    => "value for aws_material"
      )
    ]
    render "/key_pairs/index.html.erb"
  end

  it "should render list of key_pairs" do
    response.should have_tag("tr>td", "value for aws_key_name", 2)
  end
end

