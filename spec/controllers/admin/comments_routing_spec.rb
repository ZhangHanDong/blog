require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Admin::CommentsController do
  describe "route generation" do
    
    it "should map { :controller => 'admin/comments', :action => 'index', :user_id => '1' } \ 
        to /admin/users/1/comments" do
      route_for(:controller => "admin/comments", :action => "index", 
                :user_id => "1").should == "/admin/users/1/comments"
    end

    it "should map { :controller => 'admin/comments', :action => 'index', :blog_id => '1' } \ 
        to /admin/blogs/1/comments" do
      route_for(:controller => "admin/comments", :action => "index", 
                :blog_id => "1").should == "/admin/blogs/1/comments"
    end      
    
    it "should map { :controller => 'admin/comments', :action => 'index', :blog_id => '1', \ 
        :user_id => '1' } to /admin/blogs/1/users/1/comments" do
      route_for(:controller => "admin/comments", :action => "index", :blog_id => '1', 
                :user_id => "1").should == "/admin/blogs/1/users/1/comments"
    end
    
    it "should map { :controller => 'admin/comments', :action => 'index', :blog_id => '1', \ 
        :post_id => '1' } to /admin/blogs/1/posts/1/comments" do
      route_for(:controller => "admin/comments", :action => "index", :blog_id => '1', 
                :post_id => "1").should == "/admin/blogs/1/posts/1/comments"
    end                   
    
    it "should map { :controller => 'admin/comments', :action => 'index', :user_id => '1', 
        :page => '10' } to /admin/users/1/comments/page/10" do
      route_for(:controller => "admin/comments", :action => "index", 
                :user_id => "1", :page => "10").should == "/admin/users/1/comments/page/10"
    end

    it "should map { :controller => 'admin/comments', :action => 'index', :blog_id => '1', \ 
        :page => '10' } to /admin/blogs/1/comments/page/10" do
      route_for(:controller => "admin/comments", :action => "index", 
                :blog_id => "1", :page => "10").should == "/admin/blogs/1/comments/page/10"
    end      
    
    it "should map { :controller => 'admin/comments', :action => 'index', :blog_id => '1',\ 
        :user_id => '1', :page => '10' } to /admin/blogs/1/users/1/comments/page/10" do
      route_for(:controller => "admin/comments", :action => "index", :blog_id => '1', 
                :user_id => "1", :page => "10").should == "/admin/blogs/1/users/1/comments/page/10"
    end
    
    it "should map { :controller => 'admin/comments', :action => 'index', :blog_id => '1', \ 
        :post_id => '1', :page => '10' } to /admin/blogs/1/posts/1/comments/page/10" do
      route_for(:controller => "admin/comments", :action => "index", :blog_id => '1', 
                :post_id => "1", :page => "10").should == "/admin/blogs/1/posts/1/comments/page/10"
    end      

    it "should map { :controller => 'admin/posts', :action => 'new', :blog_id => '1' } \ 
        to /admin/blogs/1/posts/1/comments/new" do
      route_for(:controller => "admin/comments", :action => "new", :blog_id => "1",
                :post_id => "1").should == "/admin/blogs/1/posts/1/comments/new"
    end

    it "should map { :controller => 'admin/posts', :action => 'show', :id => '1', \ 
        :blog_id => '1' } to /admin/blogs/1/posts/1/comments/1" do
      route_for(:controller => "admin/comments", :action => "show", :blog_id => "1", 
                :post_id => "1", :id => "1").should == "/admin/blogs/1/posts/1/comments/1"
    end
                                                                                               
    it "should map { :controller => 'admin/posts', :action => 'edit', :id => '1', \ 
        :blog_id => '1' } to /admin/blogs/1/posts/1/comments/1/edit" do
      route_for(:controller => "admin/comments", :action => "edit", :blog_id => "1", 
                :post_id => "1", :id => "1").should == "/admin/blogs/1/posts/1/comments/1/edit"
    end

    it "should map { :controller => 'admin/posts', :action => 'update', :id => '1', \ 
        :blog_id => '1' } to /admin/blogs/1/posts/1/comments/1" do
      route_for(:controller => "admin/comments", :action => "update", :blog_id => "1", 
                :post_id => "1", :id => "1").should == "/admin/blogs/1/posts/1/comments/1"
    end

    it "should map { :controller => 'admin/posts', :action => 'destroy', :id => '1', \ 
        :blog_id => '1' } to /admin/blogs/1/posts/1/comments/1" do
      route_for(:controller => "admin/comments", :action => "destroy", :blog_id => "1", 
                :post_id => "1", :id => "1").should == "/admin/blogs/1/posts/1/comments/1"
    end
  end


  describe "route recognition" do
     
    it "should generate params { :controller => 'admin/comments', action => 'index', \ 
        :user_id => '1' } from GET /admin/users/1/comments" do
      params_from(:get, "/admin/users/1/comments").should == { :controller => "admin/comments", 
                                                               :action => "index", :user_id => "1" }
    end
    
    it "should generate params { :controller => 'admin/comments', action => 'index', \ 
        :blog_id => '1' } from GET /admin/blogs/1/comments" do
      params_from(:get, "/admin/blogs/1/comments").should == { :controller => "admin/comments", 
                                                               :action => "index", :blog_id => "1" }
    end
    
    it "should generate params { :controller => 'admin/comments', action => 'index', \ 
        :blog_id => '1', :user_id => '1' } from GET /admin/blogs/1/users/1/comments" do
      params_from(:get, "/admin/blogs/1/users/1/comments").should == { :controller => "admin/comments",
                                                                       :action => "index", 
                                                                       :blog_id => "1", 
                                                                       :user_id => "1" }
    end
    
    it "should generate params { :controller => 'admin/comments', action => 'index', \ 
        :blog_id => '1', :post_id => '1' } from GET /admin/blogs/1/posts/1/comments" do
      params_from(:get, "/admin/blogs/1/posts/1/comments").should == { :controller => "admin/comments", 
                                                                       :action => "index",
                                                                       :blog_id => "1", 
                                                                       :post_id => "1" }
    end
    
    it "should generate params { :controller => 'admin/comments', action => 'index', \ 
        :user_id => '1', :page => '10' } from GET /admin/users/1/comments/page/10" do
      params_from(:get, "/admin/users/1/comments/page/10").should == { :controller => "admin/comments", 
                                                                       :action => "index", 
                                                                       :page => "10",
                                                                       :user_id => "1" }
    end
    
    it "should generate params { :controller => 'admin/comments', action => 'index', \ 
        :blog_id => '1', :page => '10' } from GET /admin/blogs/1/comments/page/10" do
      params_from(:get, "/admin/blogs/1/comments/page/10").should == { :controller => "admin/comments", 
                                                                       :action => "index",
                                                                       :page => "10",
                                                                       :blog_id => "1" }
    end
    
    it "should generate params { :controller => 'admin/comments', action => 'index', \ 
        :blog_id => '1', :user_id => '1', :page => '10' } from GET /admin/blogs/1/users/1/comments/page/10" do
      params_from(:get, "/admin/blogs/1/users/1/comments/page/10").should == { :controller => "admin/comments",
                                                                               :action => "index", 
                                                                               :blog_id => "1", 
                                                                               :page => "10",
                                                                               :user_id => "1" }
    end
    
    it "should generate params { :controller => 'admin/comments', action => 'index', \ 
        :blog_id => '1', :post_id => '1', :page => '10' } from GET /admin/blogs/1/posts/1/comments/page/10" do
      params_from(:get, "/admin/blogs/1/posts/1/comments/page/10").should == { :controller => "admin/comments", 
                                                                               :action => "index",
                                                                               :blog_id => "1", 
                                                                               :page => "10",
                                                                               :post_id => "1" }
    end
    
    it "should generate params { :controller => 'admin/comments', action => 'new', \ 
        :blog_id => '1', :post_id => '1' } from GET /admin/blogs/1/posts/1/comments/new" do
      params_from(:get, "/admin/blogs/1/posts/1/comments/new").should == {:controller => "admin/comments", 
                                                                          :action => "new",
                                                                          :blog_id => "1",
                                                                          :post_id => "1"}
    end

    it "should generate params { :controller => 'admin/comments', action => 'create', \ 
        :blog_id => '1', :post_id => '1' } from POST /admin/blogs/1/posts/1/comments" do
      params_from(:post, "/admin/blogs/1/posts/1/comments").should == {:controller => "admin/comments", 
                                                                       :action => "create",
                                                                       :blog_id => "1",
                                                                       :post_id => "1"}
    end

    it "should generate params { :controller => 'admin/comments', action => 'show', \ 
        :blog_id => '1', :post_id => '1', id => '1' } from GET /admin/blogs/1/posts/1/comments/1" do
      params_from(:get, "/admin/blogs/1/posts/1/comments/1").should == {:controller => "admin/comments",
                                                                        :action => "show",
                                                                        :blog_id => "1",
                                                                        :post_id => "1",
                                                                        :id => "1"}
    end

    it "should generate params { :controller => 'admin/comments', action => 'edit', \ 
        :blog_id => '1', :post_id => '1', id => '1' } from GET /admin/blogs/1/posts/1/comments/1;edit" do
      params_from(:get, "/admin/blogs/1/posts/1/comments/1/edit").should == {:controller => "admin/comments", 
                                                                             :action => "edit",
                                                                             :blog_id => "1",
                                                                             :post_id => "1",
                                                                             :id => "1"}
    end

    it "should generate params { :controller => 'admin/comments', action => 'update', \ 
        :blog_id => '1', :post_id => '1', id => '1' } from PUT /admin/blogs/1/posts/1/comments/1" do
      params_from(:put, "/admin/blogs/1/posts/1/comments/1").should == {:controller => "admin/comments", 
                                                                        :action => "update",
                                                                        :blog_id => "1",
                                                                        :post_id => "1",
                                                                        :id => "1"}
    end

    it "should generate params { :controller => 'admin/comments', action => 'destroy', \ 
        :blog_id => '1', :post_id => '1', id => '1' } from DELETE /admin/blogs/1/posts/1/comments/1" do
      params_from(:delete, "/admin/blogs/1/posts/1/comments/1").should == {:controller => "admin/comments", 
                                                                           :action => "destroy",
                                                                           :blog_id => "1",
                                                                           :post_id => "1",
                                                                           :id => "1"}
    end
  end
end
