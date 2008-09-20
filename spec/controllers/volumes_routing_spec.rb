require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe VolumesController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "volumes", :action => "index").should == "/volumes"
    end
  
    it "should map #new" do
      route_for(:controller => "volumes", :action => "new").should == "/volumes/new"
    end
  
    it "should map #show" do
      route_for(:controller => "volumes", :action => "show", :id => 1).should == "/volumes/1"
    end
  
    it "should map #edit" do
      route_for(:controller => "volumes", :action => "edit", :id => 1).should == "/volumes/1/edit"
    end
  
    it "should map #update" do
      route_for(:controller => "volumes", :action => "update", :id => 1).should == "/volumes/1"
    end
  
    it "should map #destroy" do
      route_for(:controller => "volumes", :action => "destroy", :id => 1).should == "/volumes/1"
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/volumes").should == {:controller => "volumes", :action => "index"}
    end
  
    it "should generate params for #new" do
      params_from(:get, "/volumes/new").should == {:controller => "volumes", :action => "new"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/volumes").should == {:controller => "volumes", :action => "create"}
    end
  
    it "should generate params for #show" do
      params_from(:get, "/volumes/1").should == {:controller => "volumes", :action => "show", :id => "1"}
    end
  
    it "should generate params for #edit" do
      params_from(:get, "/volumes/1/edit").should == {:controller => "volumes", :action => "edit", :id => "1"}
    end
  
    it "should generate params for #update" do
      params_from(:put, "/volumes/1").should == {:controller => "volumes", :action => "update", :id => "1"}
    end
  
    it "should generate params for #destroy" do
      params_from(:delete, "/volumes/1").should == {:controller => "volumes", :action => "destroy", :id => "1"}
    end
  end
end
