require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/layouts/application" do

  it "should have a heading for 'Vapor'" do
    render 'layouts/application'
    response.should have_tag('h1', %r[Vapor])
  end


  describe "when logged in" do
    it "should have a 'Logout' link" do
      template.stub!(:logged_in?).and_return(true)
      render 'layouts/application'
      response.should have_tag('a', %r[Logout])
    end
  end

  describe "when not logged in" do
    before do
      render 'layouts/application'
    end

    it "should have a 'Login' link" do
      response.should have_tag('a', %r[Login])
    end

    it "should have a 'Signup' link" do
      response.should have_tag('a', %r[Signup])
    end
  end

end
