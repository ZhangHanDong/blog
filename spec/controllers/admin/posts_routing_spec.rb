require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Admin::PostsController do
  describe "route generation" do
    
    it "should map { :controller => 'admin/posts', :action => 'index', :blog_id => '1' } \ 
        to /admin/blogs/1/posts" do
      route_for(:controller => "admin/posts", :action => "index", 
                :blog_id => "1").should == "/admin/blogs/1/posts"
    end
     
    it "should map { :controller => 'admin/posts', :action => 'index', :user_id => '1', \ 
        :blog_id => '1' } to /admin/blogs/1/users/1/posts" do
      route_for(:controller => "admin/posts", :action => "index", :user_id => "1", 
                :blog_id => "1").should == "/admin/blogs/1/users/1/posts"
    end                                                                            
    
    it "should map { :controller => 'admin/posts', :action => 'index', :tag_id => '1', \ 
        :blog_id => '1' } to /admin/blogs/1/tags/1/posts" do
      route_for(:controller => "admin/posts", :action => "index", :tag_id => "1", 
                :blog_id => "1").should == "/admin/blogs/1/tags/1/posts"
    end   
    
    it "should map { :controller => 'admin/posts', :action => 'index', :user_id => '1' } \ 
        to /admin/users/1/posts" do
      route_for(:controller => "admin/posts", :action => "index", 
                :user_id => "1").should == "/admin/users/1/posts"
    end
    
    
    
    it "should map { :controller => 'admin/posts', :action => 'new', :blog_id => '1' } \ 
        to /admin/blogs/1/posts/new" do
      route_for(:controller => "admin/posts", :action => "new", 
                :blog_id => "1").should == "/admin/blogs/1/posts/new"
    end
  
    it "should map { :controller => 'admin/posts', :action => 'show', :blog_id => '1', :id => '1' } \ 
        to /admin/blogs/1/posts/1" do
      route_for(:controller => "admin/posts", :action => "show", :blog_id => "1", 
                :id => "1").should == "/admin/blogs/1/posts/1"
    end
  
    it "should map { :controller => 'admin/posts', :action => 'edit', :blog_id => '1', :id => '1' } \ 
        to /admin/blogs/1/posts/1/edit" do
      route_for(:controller => "admin/posts", :action => "edit", :blog_id => "1", 
                :id => "1").should == "/admin/blogs/1/posts/1/edit"
    end
  
    it "should map { :controller => 'admin/posts', :action => 'update', :blog_id => '1', :id => '1'} \ 
        to /admin/blogs/1/posts/1" do
      route_for(:controller => "admin/posts", :action => "update", :blog_id => "1", 
                :id => "1").should == "/admin/blogs/1/posts/1"
    end
  
    it "should map { :controller => 'admin/posts', :action => 'destroy', :blog_id => '1', :id => '1'} \ 
        to /admin/blogs/1/posts/1" do
      route_for(:controller => "admin/posts", :action => "destroy", :blog_id => "1", 
                :id => "1").should == "/admin/blogs/1/posts/1"
    end 

  end
  
  

  describe "route recognition" do

    it "should generate params { :controller => 'admin/posts', action => 'index', :blog_id => '1' } \ 
       from GET /admin/blogs/1/posts" do
      params_from(:get, "/admin/blogs/1/posts").should == {:controller => "admin/posts", 
                                                           :action => "index", :blog_id => "1"}
    end
    
    it "should generate params { :controller => 'admin/posts', action => 'index', :blog_id => '1', \ 
        :user_id => '1' } from GET /admin/blogs/1/users/1/posts" do
      params_from(:get, "/admin/blogs/1/users/1/posts").should == {:controller => "admin/posts", 
                                                                   :action => "index",
                                                                   :blog_id => "1", :user_id => "1"}
    end
    
    it "should generate params { :controller => 'admin/posts', action => 'index', :blog_id => '1', \ 
        :tag_id => '1' } from GET /admin/blogs/1/tags/1/posts" do
      params_from(:get, "/admin/blogs/1/tags/1/posts").should == {:controller => "admin/posts", 
                                                                  :action => "index", 
                                                                  :blog_id => "1", :tag_id => "1"}
    end       
    
    it "should generate params { :controller => 'admin/posts', action => 'index' } from GET \ 
        /admin/users/1/posts" do
      params_from(:get, "/admin/users/1/posts").should == {:controller => "admin/posts", 
                                                           :action => "index", :user_id => "1"}
    end
    
    
      
    it "should generate params { :controller => 'admin/posts', action => 'new', :blog_id => '1' } \ 
        from GET /admin/blogs/1/posts/new" do
      params_from(:get, "/admin/blogs/1/posts/new").should == {:controller => "admin/posts", 
                                                               :action => "new", :blog_id => "1"}
    end
  
    it "should generate params { :controller => 'admin/posts', action => 'create', :blog_id => '1' } \ 
        from POST /admin/blogs/1/posts" do
      params_from(:post, "/admin/blogs/1/posts").should == {:controller => "admin/posts", 
                                                            :action => "create", :blog_id => "1"}
    end
  
    it "should generate params { :controller => 'admin/posts', action => 'show', :blog_id => '1', \ 
        id => '1' } from GET /admin/blogs/1/posts/1" do
      params_from(:get, "/admin/blogs/1/posts/1").should == {:controller => "admin/posts",
                                                             :action => "show", 
                                                             :blog_id => "1",
                                                             :id => "1"}
    end
  
    it "should generate params { :controller => 'admin/posts', action => 'edit', :blog_id => '1', \ 
        id => '1' } from GET /admin/blogs/1/posts/1;edit" do
      params_from(:get, "/admin/blogs/1/posts/1/edit").should == {:controller => "admin/posts", 
                                                                  :action => "edit", 
                                                                  :blog_id => "1",
                                                                  :id => "1"}
    end
  
    it "should generate params { :controller => 'admin/posts', action => 'update', :blog_id => '1', \ 
        id => '1' } from PUT /admin/blogs/1/posts/1" do
      params_from(:put, "/admin/blogs/1/posts/1").should == {:controller => "admin/posts", 
                                                             :action => "update",
                                                             :blog_id => "1",
                                                             :id => "1"}
    end
  
    it "should generate params { :controller => 'admin/posts', action => 'destroy', :blog_id => '1', \ 
        id => '1' } from DELETE /admin/blogs/1/posts/1" do
      params_from(:delete, "/admin/blogs/1/posts/1").should == {:controller => "admin/posts",
                                                                :action => "destroy", 
                                                                :blog_id => "1",
                                                                :id => "1"}
    end  

  end
end
