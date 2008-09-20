require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SnapshotsController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "snapshots", :action => "index").should == "/snapshots"
    end
  
    it "should map #new" do
      route_for(:controller => "snapshots", :action => "new").should == "/snapshots/new"
    end
  
    it "should map #show" do
      route_for(:controller => "snapshots", :action => "show", :id => 1).should == "/snapshots/1"
    end
  
    it "should map #edit" do
      route_for(:controller => "snapshots", :action => "edit", :id => 1).should == "/snapshots/1/edit"
    end
  
    it "should map #update" do
      route_for(:controller => "snapshots", :action => "update", :id => 1).should == "/snapshots/1"
    end
  
    it "should map #destroy" do
      route_for(:controller => "snapshots", :action => "destroy", :id => 1).should == "/snapshots/1"
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/snapshots").should == {:controller => "snapshots", :action => "index"}
    end
  
    it "should generate params for #new" do
      params_from(:get, "/snapshots/new").should == {:controller => "snapshots", :action => "new"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/snapshots").should == {:controller => "snapshots", :action => "create"}
    end
  
    it "should generate params for #show" do
      params_from(:get, "/snapshots/1").should == {:controller => "snapshots", :action => "show", :id => "1"}
    end
  
    it "should generate params for #edit" do
      params_from(:get, "/snapshots/1/edit").should == {:controller => "snapshots", :action => "edit", :id => "1"}
    end
  
    it "should generate params for #update" do
      params_from(:put, "/snapshots/1").should == {:controller => "snapshots", :action => "update", :id => "1"}
    end
  
    it "should generate params for #destroy" do
      params_from(:delete, "/snapshots/1").should == {:controller => "snapshots", :action => "destroy", :id => "1"}
    end
  end
end
