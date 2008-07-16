require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PostsController do

  describe "handling GET /posts" do

    before(:each) do
      @post = mock_model(Post)
      Post.stub!(:find).and_return([@post])
    end

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
      Post.should_receive(:find).with(:all, {:offset=>0, :limit=>10, :include=>[:comments, :user, :tags]}).and_return([@post])
      do_get
    end

    it "should assign the found posts for the view" do
      do_get
      assigns[:posts].should == [@post]
    end
  end  
      
  
  describe "handling GET /posts.atom" do

    before(:each) do
      @posts = mock_model(Post)  
      Post.stub!(:find).and_return(@posts)
    end

    def do_get
      @request.env["HTTP_ACCEPT"] = "application/atom+xml"
      get :index
    end

    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should find all posts" do
      Post.should_receive(:find).with(:all, :include => [:comments, :user]).and_return(@posts)
      do_get
    end

  end
  
  describe "handling GET /posts/1" do

    before(:each) do
      @post = mock_model(Post)
      Post.stub!(:find).and_return(@post) 
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
      Post.should_receive(:find).with("1", {:include=>[:comments, :user, :tags]}).and_return(@post)
      do_get
    end

    it "should assign the found post for the view" do
      do_get
      assigns[:post].should equal(@post)
    end
  end  
  
  describe "handling unsuccessful GET for /posts/15155199" do
    it "should be redirected with flash message" do
      get :show, :id => "15155199"    
      response.should redirect_to(root_url)
      flash[:notice].should_not be_empty
    end
  end
  
end
