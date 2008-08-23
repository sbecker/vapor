require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/accounts/show.html.erb" do
  include AccountsHelper
  
  before(:each) do
    assigns[:account] = @account = stub_model(Account,
      :name => "value for name",
      :aws_account_number => "value for aws_account_number",
      :aws_access_key => "value for aws_access_key",
      :aws_secret_access_key => "value for aws_secret_access_key",
      :aws_x_509_key => "-----BEGIN PRIVATE KEY----- asdf87234kjhsdfjkhasdfkjh34hkjh23kjh34kjh34",
      :aws_x_509_certificate => "-----BEGIN CERTIFICATE----- alskdjfhasdjklfhasdlkjfhasdflkjhasldjflasdjkf"
    )
  end

  it "should render attributes in <p>" do
    render "/accounts/show.html.erb"
    response.should have_tag('h2', /Account/)

    response.should have_text(%r[#{@account.name}])
    response.should have_text(%r[#{@account.aws_account_number}])
    response.should have_text(%r[#{@account.aws_access_key}])
    response.should have_text(%r[#{template.truncate(@account.aws_secret_access_key, 20)}])
    response.should have_text(%r[#{template.truncate(@account.aws_x_509_key, 60)}])
    response.should have_text(%r[#{template.truncate(@account.aws_x_509_certificate, 60)}])
  end
end

