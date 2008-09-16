require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/key_pairs/new.html.erb" do
  include KeyPairsHelper
  
  before(:each) do
    assigns[:key_pair] = stub_model(KeyPair,
      :new_record? => true,
      :aws_key_name => "value for aws_key_name"
    )
  end

  it "should render new form" do
    render "/key_pairs/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", key_pairs_path) do
      with_tag("input#key_pair_aws_key_name[name=?]", "key_pair[aws_key_name]")
    end
  end
end


