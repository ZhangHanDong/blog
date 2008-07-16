require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Admin::TagsController do
  describe "route generation" do

    it "should map { :controller => 'admin/tags', :action => 'index' } to /admin/tags" do
      route_for(:controller => "admin/tags", :action => "index").should == "/admin/tags"
    end
  
    it "should map { :controller => 'admin/tags', :action => 'show', :id => 1 } to /admin/tags/1" do
      route_for(:controller => "admin/tags", :action => "show", :id => 1).should == "/admin/tags/1"
    end
 
  end

  describe "route recognition" do

    it "should generate params { :controller => 'admin/tags', action => 'index' } from GET /admin/tags" do
      params_from(:get, "/admin/tags").should == {:controller => "admin/tags", :action => "index"}
    end
  
    it "should generate params { :controller => 'admin/tags', action => 'show', id => '1' } from GET /admin/tags/1" do
      params_from(:get, "/admin/tags/1").should == {:controller => "admin/tags", :action => "show", :id => "1"}
    end

  end
end
