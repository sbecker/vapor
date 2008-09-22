require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ApplicationHelper do
  include ApplicationHelper

  describe "search links" do

    before do
      @name  = "display text"
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

  describe "form helpers" do

    describe "formatting an array for select box" do

      before do
        @items = [mock('Item', :id => 1, :name => 'foo'), mock('Item', :id => 2, :name => 'bar')]
      end

      it "should return a single array of strings if passed only a value attribute" do
        format_array_for_select(@items, :name).should == ['foo', 'bar']
      end

      it "should return a nested array containing values and display text if passed both a value and text attribute" do
        format_array_for_select(@items, :name, :id).should == [['foo', 1], ['bar', 2]]
      end

    end

  end

end
