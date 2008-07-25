require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Admin::PostsController do
  describe "route generation" do

    it "should map { :controller => 'admin/posts', :action => 'index' } to /admin/posts" do
      route_for(:controller => "admin/posts", :action => "index").should == "/admin"
    end
  
    it "should map { :controller => 'admin/posts', :action => 'new' } to /admin/posts/new" do
      route_for(:controller => "admin/posts", :action => "new").should == "/admin/posts/new"
    end
  
    it "should map { :controller => 'admin/posts', :action => 'show', :id => 1 } to /admin/posts/1" do
      route_for(:controller => "admin/posts", :action => "show", :id => 1).should == "/admin/posts/1"
    end
  
    it "should map { :controller => 'admin/posts', :action => 'edit', :id => 1 } to /admin/posts/1/edit" do
      route_for(:controller => "admin/posts", :action => "edit", :id => 1).should == "/admin/posts/1/edit"
    end
  
    it "should map { :controller => 'admin/posts', :action => 'update', :id => 1} to /admin/posts/1" do
      route_for(:controller => "admin/posts", :action => "update", :id => 1).should == "/admin/posts/1"
    end
  
    it "should map { :controller => 'admin/posts', :action => 'destroy', :id => 1} to /admin/posts/1" do
      route_for(:controller => "admin/posts", :action => "destroy", :id => 1).should == "/admin/posts/1"
    end 
    
    it "should map { :controller => 'admin/posts', :action => 'index', :user_id => '1' } to /admin/users/1/posts" do
      route_for(:controller => "admin/posts", :action => "index", :user_id => "1").should == "/admin/users/1/posts"
    end  
    
    it "should map { :controller => 'admin/posts', :action => 'show', :id => 1, :user_id => '1' } to /admin/users/1/posts/1" do
      route_for(:controller => "admin/posts", :action => "show", :id => 1, :user_id => '1').should == "/admin/users/1/posts/1"
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => 'admin/posts', action => 'index' } from GET /admin/posts" do
      params_from(:get, "/admin/posts").should == {:controller => "admin/posts", :action => "index"}
    end
  
    it "should generate params { :controller => 'admin/posts', action => 'new' } from GET /admin/posts/new" do
      params_from(:get, "/admin/posts/new").should == {:controller => "admin/posts", :action => "new"}
    end
  
    it "should generate params { :controller => 'admin/posts', action => 'create' } from POST /admin/posts" do
      params_from(:post, "/admin/posts").should == {:controller => "admin/posts", :action => "create"}
    end
  
    it "should generate params { :controller => 'admin/posts', action => 'show', id => '1' } from GET /admin/posts/1" do
      params_from(:get, "/admin/posts/1").should == {:controller => "admin/posts", :action => "show", :id => "1"}
    end
  
    it "should generate params { :controller => 'admin/posts', action => 'edit', id => '1' } from GET /admin/posts/1;edit" do
      params_from(:get, "/admin/posts/1/edit").should == {:controller => "admin/posts", :action => "edit", :id => "1"}
    end
  
    it "should generate params { :controller => 'admin/posts', action => 'update', id => '1' } from PUT /admin/posts/1" do
      params_from(:put, "/admin/posts/1").should == {:controller => "admin/posts", :action => "update", :id => "1"}
    end
  
    it "should generate params { :controller => 'admin/posts', action => 'destroy', id => '1' } from DELETE /admin/posts/1" do
      params_from(:delete, "/admin/posts/1").should == {:controller => "admin/posts", :action => "destroy", :id => "1"}
    end  
    
    it "should generate params { :controller => 'admin/posts', action => 'index' } from GET /admin/users/1/posts" do
      params_from(:get, "/admin/users/1/posts").should == {:controller => "admin/posts", :action => "index", :user_id => "1"}
    end  
    
    it "should generate params { :controller => 'admin/posts', action => 'show', id => '1' } from GET /admin/users/1/posts/1" do
      params_from(:get, "/admin/users/1/posts/1").should == {:controller => "admin/posts", :action => "show", :id => "1", :user_id => "1"}
    end
  end
end
