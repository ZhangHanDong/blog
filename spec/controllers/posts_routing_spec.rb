require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PostsController do

  describe "route generation" do

    it "should map { :controller => 'posts', :action => 'index', :blog_id => '1' } \ 
        to /blogs/1/posts" do
      route_for(:controller => "posts", :action => "index", 
                :blog_id => "1").should == "/blogs/1"
    end
    
    it "should map { :controller => 'posts', :action => 'index', :blog_id => '1', :page => '10' } \ 
        to /blogs/1/posts/page/10" do
      route_for(:controller => "posts", :action => "index", :page => "10",
                :blog_id => "1").should == "/blogs/1/posts/page/10"
    end
    
    it "should map { :controller => 'posts', :action => 'index', :blog_id => '1', :user_id => '1' } \ 
        to /blogs/1/users/1/posts" do
      route_for(:controller => "posts", :action => "index", 
                :blog_id => "1", :user_id => "1").should == "/blogs/1/users/1/posts"
    end

    it "should map { :controller => 'posts', :action => 'index', :blog_id => '1', :user_id => '1', :page => '10' } \ 
        to /blogs/1/users/1/posts/page/10" do
      route_for(:controller => "posts", :action => "index", :page => "10", 
                :blog_id => "1", :user_id => "1").should == "/blogs/1/users/1/posts/page/10"
    end  

    it "should map { :controller => 'posts', :action => 'on', :blog_id => '1', :year => '2008' } \ 
        to /blogs/1/2008" do
      route_for(:controller => "posts", :action => "on", 
                :blog_id => "1", :year => "2008").should == "/blogs/1/2008"
    end
    
    it "should map { :controller => 'posts', :action => 'on', :blog_id => '1', :year => '2008', :page => '10' } \ 
        to /blogs/1/2008/page/10" do
      route_for(:controller => "posts", :action => "on", :page => "10",  
                :blog_id => "1", :year => "2008").should == "/blogs/1/2008/page/10"
    end

    it "should map { :controller => 'posts', :action => 'on', :blog_id => '1', :year => '2007', :month => '6' } \ 
        to /blogs/1/2007/6" do
      route_for(:controller => "posts", :action => "on", 
                :blog_id => "1", :year => "2007", :month => "6").should == "/blogs/1/2007/6"
    end
    
    it "should map { :controller => 'posts', :action => 'on', :blog_id => '1', :year => '2007', :month => '6', :page => '10' } \ 
        to /blogs/1/2007/6/" do
      route_for(:controller => "posts", :action => "on", :page => "10",   
                :blog_id => "1", :year => "2007", :month => "6").should == "/blogs/1/2007/6/page/10"
    end

    it "should map { :controller => 'posts', :action => 'on', :blog_id => '1', :year => '2006', :month => '4', :day => '22' } \ 
        to /blogs/1/2006/4/22" do
      route_for(:controller => "posts", :action => "on", 
                :blog_id => "1", :year => "2006", :month => '4', :day => '22').should == "/blogs/1/2006/4/22"
    end
    
    it "should map { :controller => 'posts', :action => 'on', :blog_id => '1', :year => '2006', :month => '4', :day => '22', :page => '10' } \ 
        to /blogs/1/2006/4/22/page/10" do
      route_for(:controller => "posts", :action => "on", :page => "10", 
                :blog_id => "1", :year => "2006", :month => '4', :day => '22').should == "/blogs/1/2006/4/22/page/10"
    end
    
    it "should map { :controller => 'posts', :action => 'tagged', :blog_id => '1', :tag => 'tag_name' } \ 
        to /blogs/1/tag_name" do
      route_for(:controller => "posts", :action => "tagged", 
                :blog_id => "1", :tag => "tag_name").should == "/blogs/1/tag_name"
    end
    
    it "should map { :controller => 'posts', :action => 'tagged', :blog_id => '1', :tag => 'tag_name', :page => '10' } \ 
        to /blogs/1/tag_name/page/10" do
      route_for(:controller => "posts", :action => "tagged", :page => "10", 
                :blog_id => "1", :tag => "tag_name").should == "/blogs/1/tag_name/page/10"
    end
    
    it "should map { :controller => 'posts', :action => 'permalink', :blog_id => '1', :year => '2006', :month => '4', :day => '22', :permalink => 'some-perma-title' } \ 
        to /blogs/1/2006/4/22" do
      route_for(:controller => "posts", :action => "permalink", 
                :blog_id => "1", :year => "2006", :month => '4', :day => '22', 
                :permalink => 'some-perma-title').should == "/blogs/1/2006/4/22/some-perma-title"
    end

  end


  describe "route recognition" do

    it "should generate params { :controller => 'posts', action => 'index', :blog_id => '1' } \ 
        from GET /blogs/1/posts" do
      params_from(:get, "/blogs/1/posts").should == {:controller => "posts", :action => "index", :blog_id => "1"}
    end
    
    it "should generate params { :controller => 'posts', action => 'index', :blog_id => '1', :page => '10' } \ 
        from GET /blogs/1/posts/page/10" do
      params_from(:get, "/blogs/1/posts/page/10").should == {:controller => "posts", :action => "index", :blog_id => "1", :page => "10"}
    end

    it "should generate params { :controller => 'posts', action => 'index', :blog_id => '1', :format => 'atom' } \ 
        from GET /blogs/1/posts.atom" do
      params_from(:get, "/blogs/1/posts.atom").should == {:controller => "posts", :action => "index", 
                                                          :blog_id => "1", :format => "atom"}
    end

    it "should generate params { :controller => 'posts', action => 'index', :blog_id => '1', user_id => '1' } \ 
        from GET /blogs/1/users/1/posts" do
      params_from(:get, "/blogs/1/users/1/posts").should == {:controller => "posts", :action => "index", 
                                                             :user_id => "1", :blog_id => "1"}
    end
    
    it "should generate params { :controller => 'posts', action => 'index', :blog_id => '1', user_id => '1', :page => '10' } \ 
        from GET /blogs/1/users/1/posts/page/10" do
      params_from(:get, "/blogs/1/users/1/posts/page/10").should == {:controller => "posts", :action => "index", 
                                                             :user_id => "1", :blog_id => "1", :page => "10"}
    end

    it "should generate params { :controller => 'posts', action => 'index', :blog_id => '1', user_id => '1', :format => 'atom' } \ 
        from GET /blogs/1/users/1/posts.atom" do
      params_from(:get, "/blogs/1/users/1/posts.atom").should == {:controller => "posts", :action => "index", 
                                                                  :blog_id => "1", :user_id => "1", :format => "atom"}
    end

    it "should generate params { :controller => 'posts', action => 'on', :blog_id => 1, :year => 2008 } \ 
        from GET /blogs/1/2008" do
      params_from(:get, "/blogs/1/2008").should == {:controller => "posts", :action => "on", :year => "2008", :blog_id => "1"}
    end
    
    it "should generate params { :controller => 'posts', action => 'on', :blog_id => 1, :year => 2008, :page => '10' } \ 
        from GET /blogs/1/2008/page/10" do
      params_from(:get, "/blogs/1/2008/page/10").should == {:controller => "posts", :action => "on", :year => "2008", :blog_id => "1", :page => "10"}
    end

    it "should generate params { :controller => 'posts', action => 'on', :blog_id => 1, :year => 2007, :month => 8 } \ 
        from GET /blogs/1/2007/8" do
      params_from(:get, "/blogs/1/2007/8").should == {:controller => "posts", :action => "on", 
                                                      :year => "2007", :month => "8", :blog_id => "1"}
    end
    
    it "should generate params { :controller => 'posts', action => 'on', :blog_id => 1, :year => 2007, :month => 8, :page => '10' } \ 
        from GET /blogs/1/2007/8/page/10" do
      params_from(:get, "/blogs/1/2007/8/page/10").should == {:controller => "posts", :action => "on", 
                                                      :year => "2007", :month => "8", :blog_id => "1", :page => "10"}
    end

    it "should generate params { :controller => 'posts', action => 'on', :blog_id => 1, :year => 2006, :month => 10, :day => 22, :blog_id => 1 } \ 
        from GET /blogs/1/2006/10/22" do
      params_from(:get, "/blogs/1/2006/10/22").should == {:controller => "posts", :action => "on", 
                                                          :year => "2006", :month => "10", :day => "22", :blog_id => "1"}
    end 
    
    it "should generate params { :controller => 'posts', action => 'on', :blog_id => 1, :year => 2006, :month => 10, :day => 22, :blog_id => 1, :page => '10' } \ 
        from GET /blogs/1/2006/10/22/page/10" do
      params_from(:get, "/blogs/1/2006/10/22/page/10").should == {:controller => "posts", :action => "on", 
                                                          :year => "2006", :month => "10", :day => "22", :blog_id => "1", :page => "10"}
    end   
    
    it "should generate params { :controller => 'posts', action => 'tagged', :blog_id => 1 } \ 
        from GET /blogs/1/tag_name" do
      params_from(:get, "/blogs/1/tag_name").should == {:controller => "posts", :action => "tagged", 
                                                        :tag => "tag_name", :blog_id => "1"}
    end
    
    it "should generate params { :controller => 'posts', action => 'tagged', :blog_id => 1, :page => '10' } \ 
        from GET /blogs/1/tag_name/page/10" do
      params_from(:get, "/blogs/1/tag_name/page/10").should == {:controller => "posts", :action => "tagged", :page => "10",
                                                        :tag => "tag_name", :blog_id => "1"}
    end 
    
    it "should generate params { :controller => 'posts', action => 'permalink', :blog_id => 1, :year => 2006, :month => 10, :day => 22, :blog_id => 1, :permalink => 'perma-link-title-1'} \ 
        from GET /blogs/1/2006/10/22/perma-link-title-1" do
      params_from(:get, "/blogs/1/2006/10/22/perma-link-title-1").should == {:controller => "posts", :action => "permalink", 
                                                                             :year => "2006", :month => "10", :day => "22", 
                                                                             :blog_id => "1", :permalink => 'perma-link-title-1'}
    end

  end

end