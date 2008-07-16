require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Admin::UsersController do
  describe "route generation" do

    it "should map { :controller => 'admin/users', :action => 'signup' } to /signup" do
      route_for(:controller => "admin/users", :action => "signup").should == "/signup"
    end

    it "should map { :controller => 'admin/users', :action => 'index' } to /admin/users" do
      route_for(:controller => "admin/users", :action => "index").should == "/admin/users"
    end

    it "should map { :controller => 'admin/users', :action => 'index' } to /admin/users" do
      route_for(:controller => "admin/users", :action => "index").should == "/admin/users"
    end

    it "should map { :controller => 'admin/users', :action => 'new' } to /admin/users/new" do
      route_for(:controller => "admin/users", :action => "new").should == "/admin/users/new"
    end

    it "should map { :controller => 'admin/users', :action => 'show', :id => 1 } to /admin/users/1" do
      route_for(:controller => "admin/users", :action => "show", :id => 1).should == "/admin/users/1"
    end

    it "should map { :controller => 'admin/users', :action => 'edit', :id => 1 } to /admin/users/1/edit" do
      route_for(:controller => "admin/users", :action => "edit", :id => 1).should == "/admin/users/1/edit"
    end

    it "should map { :controller => 'admin/users', :action => 'update', :id => 1} to /admin/users/1" do
      route_for(:controller => "admin/users", :action => "update", :id => 1).should == "/admin/users/1"
    end

    it "should map { :controller => 'admin/users', :action => 'destroy', :id => 1} to /admin/users/1" do
      route_for(:controller => "admin/users", :action => "destroy", :id => 1).should == "/admin/users/1"
    end
  end

  describe "route recognition" do
    
    it "should generate params { :controller => 'admin/users', action => 'signup' } from GET /signup" do
      params_from(:get, "/signup").should == {:controller => "admin/users", :action => "signup"}
    end

    it "should generate params { :controller => 'admin/users', action => 'index' } from GET /admin/users" do
      params_from(:get, "/admin/users").should == {:controller => "admin/users", :action => "index"}
    end

    it "should generate params { :controller => 'admin/users', action => 'new' } from GET /admin/users/new" do
      params_from(:get, "/admin/users/new").should == {:controller => "admin/users", :action => "new"}
    end

    it "should generate params { :controller => 'admin/users', action => 'create' } from POST /admin/users" do
      params_from(:post, "/admin/users").should == {:controller => "admin/users", :action => "create"}
    end

    it "should generate params { :controller => 'admin/users', action => 'show', id => '1' } from GET /admin/users/1" do
      params_from(:get, "/admin/users/1").should == {:controller => "admin/users", :action => "show", :id => "1"}
    end

    it "should generate params { :controller => 'admin/users', action => 'edit', id => '1' } from GET /admin/users/1;edit" do
      params_from(:get, "/admin/users/1/edit").should == {:controller => "admin/users", :action => "edit", :id => "1"}
    end

    it "should generate params { :controller => 'admin/users', action => 'update', id => '1' } from PUT /admin/users/1" do
      params_from(:put, "/admin/users/1").should == {:controller => "admin/users", :action => "update", :id => "1"}
    end

    it "should generate params { :controller => 'admin/users', action => 'destroy', id => '1' } from DELETE /admin/users/1" do
      params_from(:delete, "/admin/users/1").should == {:controller => "admin/users", :action => "destroy", :id => "1"}
    end
  end
end
