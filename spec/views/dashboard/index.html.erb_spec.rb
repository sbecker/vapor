require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/dashboard/index" do
  before(:each) do
    render 'dashboard/index'
  end

  it "should have a heading for 'Dashboard'" do
    response.should have_tag('h2', %r[Dashboard])
  end

end
