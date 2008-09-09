require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AccountsController do
  describe "route generation" do
    it "should map #new" do
      route_for(:controller => "accounts", :action => "new").should == "/account/new"
    end
  
    it "should map #show" do
      route_for(:controller => "accounts", :action => "show").should == "/account"
    end
  
    it "should map #edit" do
      route_for(:controller => "accounts", :action => "edit").should == "/account/edit"
    end
  
    it "should map #update" do
      route_for(:controller => "accounts", :action => "update").should == "/account"
    end
  
    it "should map #destroy" do
      route_for(:controller => "accounts", :action => "destroy").should == "/account"
    end

    it "should map #sync" do
      route_for(:controller => "accounts", :action => "sync").should == "/account/sync"
    end
  end

  describe "route recognition" do
    it "should generate params for #new" do
      params_from(:get, "/account/new").should == {:controller => "accounts", :action => "new"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/account").should == {:controller => "accounts", :action => "create"}
    end
  
    it "should generate params for #show" do
      params_from(:get, "/account").should == {:controller => "accounts", :action => "show"}
    end
  
    it "should generate params for #edit" do
      params_from(:get, "/account/edit").should == {:controller => "accounts", :action => "edit"}
    end
  
    it "should generate params for #update" do
      params_from(:put, "/account").should == {:controller => "accounts", :action => "update"}
    end
  
    it "should generate params for #destroy" do
      params_from(:delete, "/account").should == {:controller => "accounts", :action => "destroy"}
    end
  
    it "should generate params for #sync" do
      params_from(:post, "/account/sync").should == {:controller => "accounts", :action => "sync"}
    end
  end
end
