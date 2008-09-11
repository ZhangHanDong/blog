require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CommentsController do

  describe "route generation" do
    it "should map { :controller => 'comments', :action => 'index', :blog_id => '1' } to /blogs/1/comments" do
      route_for(:controller => "comments", :action => "index", :blog_id => "1").should == "/blogs/1/comments"
    end

    it "should map { :controller => 'comments', :action => 'index', :blog_id => '1', :post_id => '1' } to /blogs/1/posts/1/comments" do
      route_for(:controller => "comments", :action => "index", :blog_id => "1", :post_id => "1").should == "/blogs/1/posts/1/comments"
    end

    it "should map { :controller => 'comments', :action => 'index', :blog_id => '1', :user_id => '1' } to /blogs/1/users/1/comments" do
      route_for(:controller => "comments", :action => "index", :blog_id => "1", :user_id => "1").should == "/blogs/1/users/1/comments"
    end
     
    it "should map { :controller => 'comments', :action => 'index', :blog_id => '1', :id => '1' } to /blogs/1/comments/1" do
      route_for(:controller => "comments", :action => "show", :blog_id => "1", :id => "1").should == "/blogs/1/comments/1"
    end

  end
                              

  describe "route recognition" do
    it "should generate params { :controller => 'comments', action => 'index', :blog_id => '1' } from GET /blogs/1/comments" do
      params_from(:get, "/blogs/1/comments").should == {:controller => "comments", :action => "index", :blog_id => "1"}
    end

    it "should generate params { :controller => 'comments', action => 'index', :blog_id => '1', :format => 'atom' } from GET /blogs/1/comments.atom" do
      params_from(:get, "/blogs/1/comments.atom").should == {:controller => "comments", :action => "index", :blog_id => "1", :format => "atom"}
    end

    it "should generate params { :controller => 'comments', action => 'index', :blog_id => '1', :post_id => '1' } from GET /blogs/1/posts/1/comments" do
      params_from(:get, "/blogs/1/posts/1/comments").should == {:controller => "comments", :action => "index", :blog_id => "1", :post_id => "1"}
    end

    it "should generate params { :controller => 'comments', action => 'index', :blog_id => '1', :format => 'atom' } from GET /blogs/1/posts/1/comments.atom" do
      params_from(:get, "/blogs/1/posts/1/comments.atom").should == {:controller => "comments", :action => "index", :blog_id => "1", :post_id => "1", :format => "atom"}
    end

    it "should generate params { :controller => 'comments', action => 'index', :blog_id => '1', :user_id => '1' } from GET /blogs/1/users/1/comments" do
      params_from(:get, "/blogs/1/users/1/comments").should == {:controller => "comments", :action => "index", :blog_id => "1", :user_id => "1"}
    end

    it "should generate params { :controller => 'comments', action => 'index', :blog_id => '1', :format => 'atom' } from GET /blogs/1/users/1/comments.atom" do
      params_from(:get, "/blogs/1/users/1/comments.atom").should == {:controller => "comments", :action => "index", :blog_id => "1", :user_id => "1",  :format => "atom"}
    end
    
    it "should generate params { :controller => 'comments', action => 'show', :blog_id => 1, id => '1' } from GET /blogs/1/comments/1" do
      params_from(:get, "/blogs/1/comments/1").should == {:controller => "comments", :action => "show", :blog_id => "1", :id => "1"}
    end
    
    it "should generate params { :controller => 'comments', action => 'create', :blog_id => 1, :post_id => 1 } from POST /admin/blogs/1/posts/1/comments" do
      params_from(:post, "/blogs/1/posts/1/comments").should == {:controller => "comments", :action => "create", :blog_id => "1", :post_id => "1"}
    end

  end

end
