require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/accounts/show.html.erb" do
  include AccountsHelper
  
  before(:each) do
    assigns[:account] = @account = stub_model(Account,
      :name => "value for name",
      :aws_account_number => "value for aws_account_number",
      :aws_access_key => "value for aws_access_key",
      :aws_secret_access_key => "value for aws_secret_access_key",
      :aws_x_509_key => "value for aws_x_509_key",
      :aws_x_509_certificate => "value for aws_x_509_certificate"
    )
  end

  it "should render attributes in <p>" do
    render "/accounts/show.html.erb"
    response.should have_text(/value\ for\ name/)
    response.should have_text(/value\ for\ aws_account_number/)
    response.should have_text(/value\ for\ aws_access_key/)
    response.should have_text(/value\ for\ aws_secret_access_key/)
    response.should have_text(/value\ for\ aws_x_509_key/)
    response.should have_text(/value\ for\ aws_x_509_certificate/)
  end
end

