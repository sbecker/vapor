require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/accounts/edit.html.erb" do
  include AccountsHelper
  
  before(:each) do
    assigns[:account] = @account = stub_model(Account,
      :new_record? => false,
      :name => "value for name",
      :aws_account_number => "value for aws_account_number",
      :aws_access_key => "value for aws_access_key",
      :aws_secret_access_key => "value for aws_secret_access_key",
      :aws_x_509_key => "value for aws_x_509_key",
      :aws_x_509_certificate => "value for aws_x_509_certificate"
    )
  end

  it "should render edit form" do
    render "/accounts/edit.html.erb"
    
    response.should have_tag("form[action=#{account_path}][method=post]") do
      with_tag('input#account_name[name=?]', "account[name]")
      with_tag('input#account_aws_account_number[name=?]', "account[aws_account_number]")
      with_tag('input#account_aws_access_key[name=?]', "account[aws_access_key]")
      with_tag('input#account_aws_secret_access_key[name=?]', "account[aws_secret_access_key]")
      with_tag('textarea#account_aws_x_509_key[name=?]', "account[aws_x_509_key]")
      with_tag('textarea#account_aws_x_509_certificate[name=?]', "account[aws_x_509_certificate]")
    end
  end
end


