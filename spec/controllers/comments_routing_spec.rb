require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CommentsController do
  
  describe "route generation" do
    it "should map { :controller => 'comments', :action => 'index' } to /posts/1/comments" do
      route_for(:controller => "comments", :action => "index", :post_id => 1).should == "/posts/1/comments"
    end
  end

  describe "route recognition" do
    it "should generate params { :controller => 'comments', action => 'index', :post_id => 1 } from GET /posts/1/comments" do
      params_from(:get, "/posts/1/comments").should == {:controller => "comments", :action => "index", :post_id => "1"}
    end

    it "should generate params { :controller => 'comments', action => 'create', :post_id => 1 } from POST /posts" do
      params_from(:post, "/posts/1/comments").should == {:controller => "comments", :action => "create", :post_id => "1"}
    end
  end
  
end
