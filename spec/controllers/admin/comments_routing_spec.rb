require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Admin::CommentsController do
  describe "route generation" do

    it "should map { :controller => 'admin/comments', :action => 'index' } to /admin/posts/1/comments" do
      route_for(:controller => "admin/comments", :action => "index", :post_id => 1).should == "/admin/posts/1/comments"
    end

    it "should map { :controller => 'admin/posts', :action => 'new' } to /admin/posts/1/comments/new" do
      route_for(:controller => "admin/comments", :action => "new", :post_id => 1).should == "/admin/posts/1/comments/new"
    end

    it "should map { :controller => 'admin/posts', :action => 'show', :id => 1 } to /admin/posts/1/comments/1" do
      route_for(:controller => "admin/comments", :action => "show", :post_id => 1, :id => 1).should == "/admin/posts/1/comments/1"
    end

    it "should map { :controller => 'admin/posts', :action => 'edit', :id => 1 } to /admin/posts/1/comments/1/edit" do
      route_for(:controller => "admin/comments", :action => "edit", :post_id => 1, :id => 1).should == "/admin/posts/1/comments/1/edit"
    end

    it "should map { :controller => 'admin/posts', :action => 'update', :id => 1} to /admin/posts/1/comments/1" do
      route_for(:controller => "admin/comments", :action => "update", :post_id => 1, :id => 1).should == "/admin/posts/1/comments/1"
    end

    it "should map { :controller => 'admin/posts', :action => 'destroy', :id => 1} to /admin/posts/1/comments/1" do
      route_for(:controller => "admin/comments", :action => "destroy", :post_id => 1, :id => 1).should == "/admin/posts/1/comments/1"
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => 'admin/comments', action => 'index', :post_id => 1 } from GET /admin/posts/1/comments" do
      params_from(:get, "/admin/posts/1/comments").should == {:controller => "admin/comments", :action => "index", :post_id => "1"}
    end

    it "should generate params { :controller => 'admin/comments', action => 'new', :post_id => 1 } from GET /admin/posts/new" do
      params_from(:get, "/admin/posts/1/comments/new").should == {:controller => "admin/comments", :action => "new", :post_id => "1"}
    end

    it "should generate params { :controller => 'admin/comments', action => 'create', :post_id => 1 } from POST /admin/posts" do
      params_from(:post, "/admin/posts/1/comments").should == {:controller => "admin/comments", :action => "create", :post_id => "1"}
    end

    it "should generate params { :controller => 'admin/comments', action => 'show', :post_id => 1, id => '1' } from GET /admin/posts/1" do
      params_from(:get, "/admin/posts/1/comments/1").should == {:controller => "admin/comments", :action => "show", :post_id => "1", :id => "1"}
    end

    it "should generate params { :controller => 'admin/comments', action => 'edit', :post_id => 1, id => '1' } from GET /admin/posts/1;edit" do
      params_from(:get, "/admin/posts/1/comments/1/edit").should == {:controller => "admin/comments", :action => "edit", :post_id => "1", :id => "1"}
    end

    it "should generate params { :controller => 'admin/comments', action => 'update', :post_id => 1, id => '1' } from PUT /admin/posts/1" do
      params_from(:put, "/admin/posts/1/comments/1").should == {:controller => "admin/comments", :action => "update", :post_id => "1", :id => "1"}
    end

    it "should generate params { :controller => 'admin/comments', action => 'destroy', :post_id => 1, id => '1' } from DELETE /admin/posts/1" do
      params_from(:delete, "/admin/posts/1/comments/1").should == {:controller => "admin/comments", :action => "destroy", :post_id => "1", :id => "1"}
    end
  end
end
