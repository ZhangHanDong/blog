require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UsersController do

  describe "route generation" do
    it "should map { :controller => 'users', :action => 'index', :blog_id => '1' } \ 
        to /blogs/1/users" do
      route_for(:controller => "users", :action => "index", :blog_id => "1").should == "/blogs/1/users"
    end

    it "should map { :controller => 'users', :action => 'show', :blog_id => '1', :user_id => '1' } \ 
        to /blogs/1/users/1" do
      route_for(:controller => "users", :action => "show", 
                :blog_id => "1", :id => "1").should == "/blogs/1/users/1"
    end

  end
                              

  describe "route recognition" do
    it "should generate params { :controller => 'users', action => 'index', :blog_id => '1' } \ 
        from GET /blogs/1/users" do
      params_from(:get, "/blogs/1/users").should == {:controller => "users", 
                                                     :action => "index", :blog_id => "1"}
    end

    it "should generate params { :controller => 'users', action => 'show', :blog_id => '1', :user_id => '1' } \ 
        from GET /blogs/1/users/1" do
      params_from(:get, "/blogs/1/users/1").should == {:controller => "users", :action => "show", 
                                                       :blog_id => "1", :id => "1"}
    end
    
  end

end
