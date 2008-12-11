require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe BlogsController do

  describe "route generation" do

    it "should map { :controller => 'blogs', :action => 'index' } to /blogs" do
      route_for(:controller => "blogs", :action => "index").should == "/blogs"
    end

    it "should map { :controller => 'blogs', :action => 'show', :id => '1' } to /blogs/1" do
      route_for(:controller => "blogs", :action => "show", :id => "1").should == "/blogs/1"
    end

  end


  describe "route recognition" do
    
    # root map recognition
    it "should generate params { :controller => 'blogs', action => 'index' } from ROOT map /" do
      params_from(:get, "/").should == {:controller => "blogs", :action => "index"}
    end

    it "should generate params { :controller => 'blogs', action => 'index' } from GET /blogs" do
      params_from(:get, "/blogs").should == {:controller => "blogs", :action => "index"}
    end

    it "should generate params { :controller => 'blogs', action => 'show', id => '1' } \ 
        from GET /blogs/1" do
      params_from(:get, "/blogs/1").should == {:controller => "blogs", :action => "show", :id => "1"}
    end

  end

end
