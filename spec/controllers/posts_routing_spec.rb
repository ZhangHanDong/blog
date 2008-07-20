require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PostsController do
  describe "route generation" do

    it "should map { :controller => 'posts', :action => 'index' } to /posts" do
      route_for(:controller => "posts", :action => "index").should == "/posts"
    end
  
    it "should map { :controller => 'posts', :action => 'show', :id => 1 } to /posts/1" do
      route_for(:controller => "posts", :action => "show", :id => 1).should == "/posts/1"
    end
    
    it "should map { :controller => 'posts', :action => 'date', :year => '2008' } to /posts/2008" do
      route_for(:controller => "posts", :action => "date", :year => "2008").should == "/posts/2008"
    end
    
    it "should map { :controller => 'posts', :action => 'date', :year => '2007', :month => '6' } to /posts/2007/6" do
      route_for(:controller => "posts", :action => "date", :year => "2007", :month => "6").should == "/posts/2007/6"
    end
    
    it "should map { :controller => 'posts', :action => 'date', :year => '2006', :month => '4', :day => '22' } to /posts/2006/4/22" do
      route_for(:controller => "posts", :action => "date", :year => "2006", :month => '4', :day => '22').should == "/posts/2006/4/22"
    end
 
  end

  describe "route recognition" do

    it "should generate params { :controller => 'posts', action => 'index' } from GET /posts" do
      params_from(:get, "/posts").should == {:controller => "posts", :action => "index"}
    end
  
    it "should generate params { :controller => 'posts', action => 'show', id => '1' } from GET /posts/1" do
      params_from(:get, "/posts/1").should == {:controller => "posts", :action => "show", :id => "1"}
    end
    
    it "should generate params { :controller => 'posts', action => 'date' } from GET /posts/2008" do
      params_from(:get, "/posts/2008").should == {:controller => "posts", :action => "date", :year => "2008"}
    end
    
    it "should generate params { :controller => 'posts', action => 'date' } from GET /posts/2007/8" do
      params_from(:get, "/posts/2007/8").should == {:controller => "posts", :action => "date", :year => "2007", :month => "8"}
    end
    
    it "should generate params { :controller => 'posts', action => 'date' } from GET /posts/2006/10/22" do
      params_from(:get, "/posts/2006/10/22").should == {:controller => "posts", :action => "date", :year => "2006", :month => "10", :day => "22"}
    end

  end
end
