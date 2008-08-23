require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PostsController do

  before(:each) do
    @post = mock_model(Post)
    @user = mock_model(User)
    User.stub!(:find).and_return(@user)
    Post.stub!(:find).and_return([@post])
  end

  describe "handling GET /posts" do

    def do_get
      get :index
    end

    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should render index template" do
      do_get
      response.should render_template('index')
    end

    it "should find all posts" do
      Post.should_receive(:find).with(:all, {:offset=>0, :limit=>10, :include=>[:comments, :user, :tags], :conditions => nil}).and_return([@post])
      do_get
    end

    it "should assign the found posts for the view" do
      do_get
      assigns[:posts].should == [@post]
    end      
  end    
  
    
  describe "handling GET /posts with date range" do

    it "should be successful on year search" do   
      Post.should_receive(:find).with(:all, {:offset=>0, :limit=>10, :include=>[:comments, :user, :tags]}).and_return([@post])
      get :date, :year => "2008"         
      response.should be_success
    end  
    
    it "should be successful on year, month search" do  
      get :date, :year => "2008", :month => '7'
      response.should be_success
    end
    
    it "should be successful on year, month and day search" do
      get :date, :year => "2008", :month => '7', :day => '23'
      response.should be_success
    end
    
    it "should show no posts found and redirect (with message) when none in date range" do
      Post.should_receive(:find).with(:all, {:offset=>0, :limit=>10, :include=>[:comments, :user, :tags]}).and_return([]) 
      get :date, :year => "2007"   
      flash[:notice].should_not be_empty       
      response.should redirect_to(posts_url) 
    end

  end
      
  
  describe "handling GET /posts.atom" do

    def do_get
      @request.env["HTTP_ACCEPT"] = "application/atom+xml"
      get :index
    end

    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should find all posts" do
      Post.should_receive(:find).with(:all, :include => [:comments, :user], :conditions => nil).and_return(@post)
      do_get
    end

  end
  
  describe "handling GET /posts/1" do

    before(:each) do
      Comment.should_receive(:new).and_return(mock_model(Comment))         
    end

    def do_get
      get :show, :id => "1"
    end

    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should render show template" do
      do_get
      response.should render_template('show')
    end

    it "should find the post requested" do
      Post.should_receive(:find).with("1", {:include=>[:comments, :user, :tags]}).and_return([@post])
      do_get
    end

    it "should assign the found post for the view" do
      Post.stub!(:find).and_return(@post)
      do_get
      assigns[:post].should equal(@post)
    end
  end     
                                         
  
  describe "handling GET /users/1/posts" do
        
    def do_get
      get :index, :user_id => "1"
    end    
    
    it "should be successful" do
      do_get
      response.should be_success
    end    
    
    it "should assign the found user for the view" do
      do_get
      assigns[:user].should equal(@user)
    end
    
  end
  
  
  describe "handling GET /users/1/posts/1" do
    
    def do_get
      get :show, :id => "1", :user_id => "1"
    end    
    
    it "should be successful" do
      do_get
      response.should be_success
    end   
    
  end    
  
  
  describe "handling unsuccessful GET for /posts/15155199" do
    it "should be redirected with flash message" do
      Post.should_receive(:find).and_raise(ActiveRecord::RecordNotFound)
      get :show, :id => "15155199"    
      response.should redirect_to(root_url)
      flash[:notice].should_not be_empty
    end
  end
  
end
