require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe InstancesController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "instances", :action => "index").should == "/instances"
    end
  
    it "should map #new" do
      route_for(:controller => "instances", :action => "new").should == "/instances/new"
    end
  
    it "should map #show" do
      route_for(:controller => "instances", :action => "show", :id => 1).should == "/instances/1"
    end
  
    it "should map #edit" do
      route_for(:controller => "instances", :action => "edit", :id => 1).should == "/instances/1/edit"
    end
  
    it "should map #update" do
      route_for(:controller => "instances", :action => "update", :id => 1).should == "/instances/1"
    end
  
    it "should map #destroy" do
      route_for(:controller => "instances", :action => "destroy", :id => 1).should == "/instances/1"
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/instances").should == {:controller => "instances", :action => "index"}
    end
  
    it "should generate params for #new" do
      params_from(:get, "/instances/new").should == {:controller => "instances", :action => "new"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/instances").should == {:controller => "instances", :action => "create"}
    end
  
    it "should generate params for #show" do
      params_from(:get, "/instances/1").should == {:controller => "instances", :action => "show", :id => "1"}
    end
  
    it "should generate params for #edit" do
      params_from(:get, "/instances/1/edit").should == {:controller => "instances", :action => "edit", :id => "1"}
    end
  
    it "should generate params for #update" do
      params_from(:put, "/instances/1").should == {:controller => "instances", :action => "update", :id => "1"}
    end
  
    it "should generate params for #destroy" do
      params_from(:delete, "/instances/1").should == {:controller => "instances", :action => "destroy", :id => "1"}
    end
  end
end
