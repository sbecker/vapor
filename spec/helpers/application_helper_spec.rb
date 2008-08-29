require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ApplicationHelper do
  include ApplicationHelper

  describe "search links" do
    before do
      @name = "display text"
      @query = "search text"
    end

    describe "for AWS" do
      it "should use the first argument as the name" do
        aws_search_link(@name, @query).should have_tag("a", @name)
      end

      it "should use the second argument in the search query link to AWS" do
        aws_search_link(@name, @query).should have_tag("a[href=http://developer.amazonwebservices.com/connect/isearch.jspa?searchQuery=#{@query}&x=0&y=0&searchKB=true&searchForums=true]")
      end
    end

    describe "for Google" do
      it "should use the first argument as the name" do
        google_search_link(@name, @query).should have_tag("a", @name)
      end

      it "should use the second argument in the search query link to Google" do
        google_search_link(@name, @query).should have_tag("a[href=http://www.google.com/search?q=#{@query}]")
      end
    end

  end

end
