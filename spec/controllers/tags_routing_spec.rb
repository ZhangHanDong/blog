require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TagsController do

  describe "route generation" do
    it "should map { :controller => 'tags', :action => 'index', :blog_id => '1' } \ 
        to /blogs/1/tags" do
      route_for(:controller => "tags", :action => "index", :blog_id => "1").should == "/blogs/1/tags"
    end

    it "should map { :controller => 'tags', :action => 'index', :blog_id => '1', :user_id => '1' } \ 
        to /blogs/1/users/1/tags" do
      route_for(:controller => "tags", :action => "index", 
                :blog_id => "1", :user_id => "1").should == "/blogs/1/users/1/tags"
    end

  end
                              

  describe "route recognition" do
    it "should generate params { :controller => 'tags', action => 'index', :blog_id => '1' } \ 
        from GET /blogs/1/comments" do
      params_from(:get, "/blogs/1/tags").should == {:controller => "tags", 
                                                    :action => "index", :blog_id => "1"}
    end

    it "should generate params { :controller => 'tags', action => 'index', :blog_id => '1', :user_id => '1' } \ 
        from GET /blogs/1/users/1/comments" do
      params_from(:get, "/blogs/1/users/1/tags").should == {:controller => "tags", :action => "index", 
                                                            :blog_id => "1", :user_id => "1"}
    end
    
  end

end
