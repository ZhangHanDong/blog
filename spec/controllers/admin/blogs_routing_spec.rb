require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Admin::BlogsController do
  describe "route generation" do
                
    it "should map { :controller => 'admin/blogs', :action => 'index' } to /admin/blogs" do
      route_for(:controller => "admin/blogs", :action => "index").should == "/admin"
    end
  
    it "should map { :controller => 'admin/blogs', :action => 'new' } to /blogs/new" do
      route_for(:controller => "admin/blogs", :action => "new").should == "/admin/blogs/new"
    end
  
    it "should map { :controller => 'admin/blogs', :action => 'show', :id => '1' } to /admin/blogs/1" do
      route_for(:controller => "admin/blogs", :action => "show", :id => "1").should == "/admin/blogs/1"
    end
  
    it "should map { :controller => 'admin/blogs', :action => 'edit', :id => '1' } to /admin/blogs/1/edit" do
      route_for(:controller => "admin/blogs", :action => "edit", :id => "1").should == "/admin/blogs/1/edit"
    end
  
    it "should map { :controller => 'admin/blogs', :action => 'update', :id => '1' } to /admin/blogs/1" do
      route_for(:controller => "admin/blogs", :action => "update", :id => "1").should == "/admin/blogs/1"
    end
  
    it "should map { :controller => 'admin/blogs', :action => 'destroy', :id => '1' } to /admin/blogs/1" do
      route_for(:controller => "admin/blogs", :action => "destroy", :id => "1").should == "/admin/blogs/1"
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => 'blogs', action => 'index' } from GET /admin/blogs" do
      params_from(:get, "/admin/blogs").should == {:controller => "admin/blogs", :action => "index"}
    end
  
    it "should generate params { :controller => 'blogs', action => 'new' } from GET /admin/blogs/new" do
      params_from(:get, "/admin/blogs/new").should == {:controller => "admin/blogs", :action => "new"}
    end
  
    it "should generate params { :controller => 'blogs', action => 'create' } from POST /admin/blogs" do
      params_from(:post, "/admin/blogs").should == {:controller => "admin/blogs", :action => "create"}
    end
  
    it "should generate params { :controller => 'blogs', action => 'show', id => '1' } from GET /admin/blogs/1" do
      params_from(:get, "/admin/blogs/1").should == {:controller => "admin/blogs", :action => "show", :id => "1"}
    end
  
    it "should generate params { :controller => 'blogs', action => 'edit', id => '1' } from GET /admin/blogs/1;edit" do
      params_from(:get, "/admin/blogs/1/edit").should == {:controller => "admin/blogs", :action => "edit", :id => "1"}
    end
  
    it "should generate params { :controller => 'blogs', action => 'update', id => '1' } from PUT /admin/blogs/1" do
      params_from(:put, "/admin/blogs/1").should == {:controller => "admin/blogs", :action => "update", :id => "1"}
    end
  
    it "should generate params { :controller => 'blogs', action => 'destroy', id => '1' } from DELETE /admin/blogs/1" do
      params_from(:delete, "/admin/blogs/1").should == {:controller => "admin/blogs", :action => "destroy", :id => "1"}
    end
  end
end
