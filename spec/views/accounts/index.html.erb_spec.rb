require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/accounts/index.html.erb" do
  include AccountsHelper
  
  before(:each) do
    assigns[:accounts] = [
      stub_model(Account,
        :name => "value for name",
        :aws_account_number => "value for aws_account_number",
        :aws_access_key => "value for aws_access_key",
        :aws_secret_access_key => "value for aws_secret_access_key",
        :aws_x_509_key => "value for aws_x_509_key",
        :aws_x_509_certificate => "value for aws_x_509_certificate"
      ),
      stub_model(Account,
        :name => "value for name",
        :aws_account_number => "value for aws_account_number",
        :aws_access_key => "value for aws_access_key",
        :aws_secret_access_key => "value for aws_secret_access_key",
        :aws_x_509_key => "value for aws_x_509_key",
        :aws_x_509_certificate => "value for aws_x_509_certificate"
      )
    ]
  end

  it "should render list of accounts" do
    render "/accounts/index.html.erb"
    response.should have_tag("tr>td", "value for name", 2)
    response.should have_tag("tr>td", "value for aws_account_number", 2)
    response.should have_tag("tr>td", "value for aws_access_key", 2)
    response.should have_tag("tr>td", "value for aws_secret_access_key", 2)
    response.should have_tag("tr>td", "value for aws_x_509_key", 2)
    response.should have_tag("tr>td", "value for aws_x_509_certificate", 2)
  end
end

