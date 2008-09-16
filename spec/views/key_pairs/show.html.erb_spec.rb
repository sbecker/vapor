require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/key_pairs/show.html.erb" do
  include KeyPairsHelper
  
  before(:each) do
    assigns[:key_pair] = @key_pair = stub_model(KeyPair,
      :aws_key_name    => "value for aws_key_name",
      :aws_fingerprint => "value for aws_fingerprint",
      :aws_material    => "value for aws_material"
    )
  end

  it "should render attributes in <p>" do
    render "/key_pairs/show.html.erb"
    response.should have_text(/value\ for\ aws_key_name/)
    response.should have_text(/value\ for\ aws_fingerprint/)
    response.should have_text(/value\ for\ aws_material/)
  end
end

