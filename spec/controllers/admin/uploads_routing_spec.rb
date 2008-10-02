require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Admin::UploadsController do
  describe "route generation" do

    it "should map { :controller => 'admin/uploads', :action => 'index' } to /admin/uploads" do
      route_for(:controller => "admin/uploads", :action => "index").should == "/admin/uploads"
    end
  
    it "should map { :controller => 'admin/uploads', :action => 'new' } to /admin/uploads/new" do
      route_for(:controller => "admin/uploads", :action => "new").should == "/admin/uploads/new"
    end
  
    it "should map { :controller => 'admin/uploads', :action => 'show', :id => 1 } to /admin/uploads/1" do
      route_for(:controller => "admin/uploads", :action => "show", :id => 1).should == "/admin/uploads/1"
    end
  
    it "should map { :controller => 'admin/uploads', :action => 'edit', :id => 1 } to /admin/uploads/1/edit" do
      route_for(:controller => "admin/uploads", :action => "edit", :id => 1).should == "/admin/uploads/1/edit"
    end
  
    it "should map { :controller => 'admin/uploads', :action => 'update', :id => 1} to /admin/uploads/1" do
      route_for(:controller => "admin/uploads", :action => "update", :id => 1).should == "/admin/uploads/1"
    end
  
    it "should map { :controller => 'admin/uploads', :action => 'destroy', :id => 1} to /admin/uploads/1" do
      route_for(:controller => "admin/uploads", :action => "destroy", :id => 1).should == "/admin/uploads/1"
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => 'admin/uploads', action => 'index' } from GET /admin/uploads" do
      params_from(:get, "/admin/uploads").should == {:controller => "admin/uploads", :action => "index"}
    end
  
    it "should generate params { :controller => 'admin/uploads', action => 'new' } from GET /admin/uploads/new" do
      params_from(:get, "/admin/uploads/new").should == {:controller => "admin/uploads", :action => "new"}
    end
  
    it "should generate params { :controller => 'admin/uploads', action => 'create' } from POST /admin/uploads" do
      params_from(:post, "/admin/uploads").should == {:controller => "admin/uploads", :action => "create"}
    end
  
    it "should generate params { :controller => 'admin/admin/uploads', action => 'show', id => '1' } from GET /admin/uploads/1" do
      params_from(:get, "/admin/uploads/1").should == {:controller => "admin/uploads", :action => "show", :id => "1"}
    end
  
    it "should generate params { :controller => 'admin/uploads', action => 'edit', id => '1' } from GET /admin/uploads/1;edit" do
      params_from(:get, "/admin/uploads/1/edit").should == {:controller => "admin/uploads", :action => "edit", :id => "1"}
    end
  
    it "should generate params { :controller => 'admin/uploads', action => 'update', id => '1' } from PUT /admin/uploads/1" do
      params_from(:put, "/admin/uploads/1").should == {:controller => "admin/uploads", :action => "update", :id => "1"}
    end
  
    it "should generate params { :controller => 'admin/uploads', action => 'destroy', id => '1' } from DELETE /admin/uploads/1" do
      params_from(:delete, "/admin/uploads/1").should == {:controller => "admin/uploads", :action => "destroy", :id => "1"}
    end
  end
end
