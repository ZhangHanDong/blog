require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Admin::TagsController do
  describe "route generation" do

    it "should map { :controller => 'admin/tags', :action => 'index', :blog_id => '1' } \ 
        to /admin/blogs/1/tags" do
      route_for(:controller => "admin/tags", :action => "index", 
                :blog_id => "1").should == "/admin/blogs/1/tags"
    end
  
    it "should map { :controller => 'admin/tags', :action => 'show', :blog_id => '1', \ 
        :id => '1' } to /admin/blogs/1/tags/1" do
      route_for(:controller => "admin/tags", :action => "show", :blog_id => "1", 
                :id => "1").should == "/admin/blogs/1/tags/1"
    end
 
  end

  describe "route recognition" do

    it "should generate params { :controller => 'admin/tags', action => 'index', :blog_id => '1' }  \ 
        from GET /admin/blogs/1/tags" do
      params_from(:get, "/admin/blogs/1/tags").should == {:controller => "admin/tags",
                                                          :action => "index", 
                                                          :blog_id => "1"}
    end
  
    it "should generate params { :controller => 'admin/tags', action => 'show', \ :blog_id => '1', \ 
        id => '1' } from GET /admin/blogs/1/tags/1" do
      params_from(:get, "/admin/blogs/1/tags/1").should == {:controller => "admin/tags", 
                                                            :action => "show", 
                                                            :id => "1",
                                                            :blog_id => "1"}
    end

  end
end
