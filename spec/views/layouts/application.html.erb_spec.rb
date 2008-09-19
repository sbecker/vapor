require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/layouts/application" do

  it "should have a heading for 'Vapor'" do
    render 'layouts/application'
    response.should have_tag('h1', %r[Vapor])
  end

  describe "when logged in" do
    before do
      template.stub!(:logged_in?).and_return(true)
      render 'layouts/application'
    end

    describe "ec2 resource links" do
      it "should have an 'Addresses' link" do
        response.should have_tag('a', %r[Addresses])
      end

      it "should have an 'Images' link" do
        response.should have_tag('a', %r[Images])
      end

      it "should have an 'Instances' link" do
        response.should have_tag('a', %r[Instances])
      end

      it "should have an 'Key Pairs' link" do
        response.should have_tag('a', %r[Key Pairs])
      end

      it "should have an 'Security Groups' link" do
        response.should have_tag('a', %r[Security Groups])
      end
    end

    describe "system links" do
      it "should have a 'Dashboard' link" do
        response.should have_tag('a', %r[Dashboard])
      end

      it "should have an 'Account' link" do
        response.should have_tag('a', %r[Account])
      end

      it "should have a 'Sync with EC2' link" do
        response.should have_tag("a", %r[Sync with EC2])
      end

      it "should have a 'Logout' link" do
        response.should have_tag('a', %r[Logout])
      end
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
