require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe KeyPairsController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "key_pairs", :action => "index").should == "/key_pairs"
    end
  
    it "should map #sync" do
      route_for(:controller => "key_pairs", :action => "sync").should == "/key_pairs/sync"
    end
  
    it "should map #new" do
      route_for(:controller => "key_pairs", :action => "new").should == "/key_pairs/new"
    end
  
    it "should map #show" do
      route_for(:controller => "key_pairs", :action => "show", :id => 1).should == "/key_pairs/1"
    end
  
    it "should map #edit" do
      route_for(:controller => "key_pairs", :action => "edit", :id => 1).should == "/key_pairs/1/edit"
    end
  
    it "should map #update" do
      route_for(:controller => "key_pairs", :action => "update", :id => 1).should == "/key_pairs/1"
    end
  
    it "should map #destroy" do
      route_for(:controller => "key_pairs", :action => "destroy", :id => 1).should == "/key_pairs/1"
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/key_pairs").should == {:controller => "key_pairs", :action => "index"}
    end
  
    it "should generate params for #sync" do
      params_from(:post, "/key_pairs/sync").should == {:controller => "key_pairs", :action => "sync"}
    end
  
    it "should generate params for #new" do
      params_from(:get, "/key_pairs/new").should == {:controller => "key_pairs", :action => "new"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/key_pairs").should == {:controller => "key_pairs", :action => "create"}
    end
  
    it "should generate params for #show" do
      params_from(:get, "/key_pairs/1").should == {:controller => "key_pairs", :action => "show", :id => "1"}
    end
  
    it "should generate params for #edit" do
      params_from(:get, "/key_pairs/1/edit").should == {:controller => "key_pairs", :action => "edit", :id => "1"}
    end
  
    it "should generate params for #update" do
      params_from(:put, "/key_pairs/1").should == {:controller => "key_pairs", :action => "update", :id => "1"}
    end
  
    it "should generate params for #destroy" do
      params_from(:delete, "/key_pairs/1").should == {:controller => "key_pairs", :action => "destroy", :id => "1"}
    end
  end
end
