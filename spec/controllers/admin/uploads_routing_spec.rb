require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Admin::UploadsController do

  describe "route generation" do

    it "should map { :controller => 'admin/uploads', :action => 'index' } \
        to /admin/blogs/1/uploads" do
      route_for(:controller => "admin/uploads", :action => "index",
                :blog_id => "1").should == "/admin/blogs/1/uploads"
    end

    it "should map { :controller => 'admin/uploads', :action => 'index', :user_id => '1', \
        :blog_id => '1' } to /admin/blogs/1/users/1/uploads" do
      route_for(:controller => "admin/uploads", :action => "index", :user_id => "1",
                :blog_id => "1").should == "/admin/blogs/1/users/1/uploads"
    end   
    
    it "should map { :controller => 'admin/uploads', :action => 'index', :page => '10' } \
        to /admin/blogs/1/uploads/page/10" do
      route_for(:controller => "admin/uploads", :action => "index",
                :blog_id => "1", :page => "10").should == "/admin/blogs/1/uploads/page/10"
    end

    it "should map { :controller => 'admin/uploads', :action => 'index', :user_id => '1', \
        :blog_id => '1', :page => '10' } to /admin/blogs/1/users/1/uploads/page/10" do
      route_for(:controller => "admin/uploads", :action => "index", :user_id => "1",
                :blog_id => "1", :page => "10").should == "/admin/blogs/1/users/1/uploads/page/10"
    end

    it "should map { :controller => 'admin/uploads', :action => 'new' } \
        to /admin/blogs/1/uploads/new" do
      route_for(:controller => "admin/uploads", :action => "new",
                :blog_id => "1").should == "/admin/blogs/1/uploads/new"
    end

    it "should map { :controller => 'admin/uploads', :action => 'show', :id => 1 } \
        to /admin/blogs/1/uploads/1" do
      route_for(:controller => "admin/uploads", :action => "show", :id => 1,
                :blog_id => "1").should == "/admin/blogs/1/uploads/1"
    end

    it "should map { :controller => 'admin/uploads', :action => 'edit', :id => 1 } \
        to /admin/blogs/1/uploads/1/edit" do
      route_for(:controller => "admin/uploads", :action => "edit", :id => 1,
                :blog_id => "1").should == "/admin/blogs/1/uploads/1/edit"
    end

    it "should map { :controller => 'admin/uploads', :action => 'update', :id => 1} \
        to /admin/blogs/1/uploads/1" do
      route_for(:controller => "admin/uploads", :action => "update", :id => 1,
                :blog_id => "1").should == "/admin/blogs/1/uploads/1"
    end

    it "should map { :controller => 'admin/uploads', :action => 'destroy', :id => 1} \
        to /admin/blogs/1/uploads/1" do
      route_for(:controller => "admin/uploads", :action => "destroy", :id => 1,
                :blog_id => "1").should == "/admin/blogs/1/uploads/1"
    end

  end


  describe "route recognition" do

    it "should generate params { :controller => 'admin/uploads', action => 'index', :blog_id => '1', \
        :user_id => '1' } from GET /admin/blogs/1/users/1/uploads" do
      params_from(:get, "/admin/blogs/1/users/1/uploads").should == { :controller => "admin/uploads",
                                                                      :action => "index",
                                                                      :blog_id => "1",
                                                                      :user_id => "1"}
    end

    it "should generate params { :controller => 'admin/uploads', action => 'index' } \
        from GET /admin/blogs/1/uploads" do
      params_from(:get, "/admin/blogs/1/uploads").should == { :controller => "admin/uploads",
                                                              :action => "index", :blog_id => "1" }
    end    
    
    it "should generate params { :controller => 'admin/uploads', action => 'index', :blog_id => '1', \
        :user_id => '1', :page => '10' } from GET /admin/blogs/1/users/1/uploads/page/10" do
      params_from(:get, "/admin/blogs/1/users/1/uploads/page/10").should == { :controller => "admin/uploads",
                                                                              :action => "index",
                                                                              :blog_id => "1",
                                                                              :page => "10",
                                                                              :user_id => "1" }
    end

    it "should generate params { :controller => 'admin/uploads', action => 'index', :page => '10' } \
        from GET /admin/blogs/1/uploads/page/10" do
      params_from(:get, "/admin/blogs/1/uploads/page/10").should == { :controller => "admin/uploads",
                                                                      :action => "index", 
                                                                      :page => "10",
                                                                      :blog_id => "1" }
    end

    it "should generate params { :controller => 'admin/uploads', action => 'new' } \
        from GET /admin/blogs/1/uploads/new" do
      params_from(:get, "/admin/blogs/1/uploads/new").should == { :controller => "admin/uploads",
                                                                  :action => "new", :blog_id => "1" }
    end

    it "should generate params { :controller => 'admin/uploads', action => 'create' } \
        from POST /admin/blogs/1/uploads" do
      params_from(:post, "/admin/blogs/1/uploads").should == { :controller => "admin/uploads",
                                                               :action => "create", :blog_id => "1" }
    end

    it "should generate params { :controller => 'admin/uploads', action => 'show', id => '1' } \
        from GET /admin/blogs/1/uploads/1" do
      params_from(:get, "/admin/blogs/1/uploads/1").should == { :controller => "admin/uploads",
                                                                :action => "show",
                                                                :id => "1",
                                                                :blog_id => "1" }
    end

    it "should generate params { :controller => 'admin/uploads', action => 'edit', id => '1' } \
        from GET /admin/blogs/1/uploads/1;edit" do
      params_from(:get, "/admin/blogs/1/uploads/1/edit").should == { :controller => "admin/uploads",
                                                                     :action => "edit", :id => "1",
                                                                     :blog_id => "1" }
    end

    it "should generate params { :controller => 'admin/uploads', action => 'update', id => '1' } \
        from PUT /admin/blogs/1/uploads/1" do
      params_from(:put, "/admin/blogs/1/uploads/1").should == { :controller => "admin/uploads",
                                                                :action => "update", :id => "1",
                                                                :blog_id => "1" }
    end

    it "should generate params { :controller => 'admin/uploads', action => 'destroy', id => '1' } \
        from DELETE /admin/blogs/1/uploads/1" do
      params_from(:delete, "/admin/blogs/1/uploads/1").should == { :controller => "admin/uploads",
                                                                   :action => "destroy", :id => "1",
                                                                   :blog_id => "1"}
    end    
    
  end
  
end