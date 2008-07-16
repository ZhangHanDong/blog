require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PostsController do
  describe "route generation" do

    it "should map { :controller => 'posts', :action => 'index' } to /posts" do
      route_for(:controller => "posts", :action => "index").should == "/posts"
    end
  
    it "should map { :controller => 'posts', :action => 'show', :id => 1 } to /posts/1" do
      route_for(:controller => "posts", :action => "show", :id => 1).should == "/posts/1"
    end
 
  end

  describe "route recognition" do

    it "should generate params { :controller => 'posts', action => 'index' } from GET /posts" do
      params_from(:get, "/posts").should == {:controller => "posts", :action => "index"}
    end
  
    it "should generate params { :controller => 'posts', action => 'show', id => '1' } from GET /posts/1" do
      params_from(:get, "/posts/1").should == {:controller => "posts", :action => "show", :id => "1"}
    end

  end
end
