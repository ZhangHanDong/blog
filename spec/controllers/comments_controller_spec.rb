require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')


describe CommentsController do

  fixtures :users

  before(:each) do
    @blog    = mock_model(Blog)
    @post    = mock_model(Post)
    @comment = mock_model(Comment)
    @user    = mock_model(User)
    
    Blog.stub!(:find).and_return(@blog)
    Post.stub!(:find).and_return(@post)
    Comment.stub!(:find).and_return(@comment)
  end


  describe "handling GET /blogs/1/comments" do

    def do_get
      get :index, :blog_id => "1"
    end

    it "should be successful, render index template and assign comments for the view" do
      @blog.should_receive(:comments).and_return(@comment)
      @comment.should_receive(:published).and_return(@comment)
      @comment.should_receive(:paginate).with(:all, {:include=>:post, :per_page=>10, :page=>nil}).and_return([@comment])
      do_get
      response.should be_success
      response.should render_template('index')
      assigns[:blog].should == @blog
      assigns[:comments].should == [@comment]
    end
  end


  describe "handling GET /blogs/1/comments.atom" do

    def do_get
      @request.env["HTTP_ACCEPT"] = "application/atom+xml"
      get :index, :blog_id => "1"
    end

    it "should be successful" do
      @blog.should_receive(:comments).and_return(@comment)
      @comment.should_receive(:published).and_return(@comment)
      @comment.should_receive(:recent).and_return([@comment])
      do_get
      response.should be_success
    end
  end


  describe "handling GET /blogs/1/posts/1/comments" do

    def do_get
      get :index, :blog_id => "1", :post_id => "1"
    end

    it "should be successful, render index template and assign comments for the view" do
      @blog.should_receive(:posts).and_return(@post)
      @post.should_receive(:published).and_return(@post)
      @post.should_receive(:find).and_return(@post)
      @post.should_receive(:comments).and_return(@comment)
      @comment.should_receive(:paginate).with(:all, {:include=>:post, :per_page=>10, :page=>nil}).and_return([@comment])
      do_get
      response.should be_success
      response.should render_template('index')
      assigns[:blog].should == @blog
      assigns[:post].should == @post
      assigns[:comments].should == [@comment]
    end
  end


  describe "handling GET /blogs/1/posts/1/comments.atom" do

    def do_get
      @request.env["HTTP_ACCEPT"] = "application/atom+xml"
      get :index, :blog_id => "1", :post_id => "1"
    end

    it "should be successful" do
      @blog.should_receive(:posts).and_return(@post)
      @post.should_receive(:published).and_return(@post)
      @post.should_receive(:find).and_return(@post)
      @post.should_receive(:comments).and_return(@comment)
      @comment.should_receive(:recent).and_return([@comment])
      do_get
      response.should be_success
    end
  end


  describe "handling GET /blogs/1/users/1/comments" do

    def do_get
      get :index, :blog_id => "1", :user_id => "1"
    end

    it "should be successful, render index template and assign comments for the view" do
      User.stub!(:find).and_return(@user)
      @blog.should_receive(:comments).and_return(@comment)
      @comment.should_receive(:published).and_return(@comment)
      @comment.should_receive(:by_user).with(@user).and_return(@comment)
      @comment.should_receive(:paginate).with(:all, {:include=>:post, :per_page=>10, :page=>nil}).and_return([@comment])
      do_get
      response.should be_success
      response.should render_template('index')
      assigns[:blog].should == @blog
      assigns[:user].should == @user
      assigns[:comments].should == [@comment]
    end

  end


  describe "handling GET /blogs/1/users/1/comments.atom" do

    def do_get
      @request.env["HTTP_ACCEPT"] = "application/atom+xml"
      get :index, :blog_id => "1", :user_id => "1"
    end

    it "should be successful" do
      User.stub!(:find).and_return(@user)
      @blog.should_receive(:comments).and_return(@comment)
      @comment.should_receive(:published).and_return(@comment)
      @comment.should_receive(:by_user).with(@user).and_return(@comment)
      @comment.should_receive(:recent).and_return([@comment])
      do_get
      response.should be_success
    end
  end


  describe "handling comment creation on /blogs/1/posts/1/comments" do

    before(:each) do
      Comment.should_receive(:new).and_return(@comment)
      @comment.should_receive(:post=).with(@post)
    end

    describe "with setting comment in post collection (and sucessful save)" do

      def do_post
        @post.should_receive(:permalink_url).and_return({:only_path => false, 
         :controller => "/posts", 
         :action => "permalink",  
         :blog_id => "1",
         :year => "2008", 
         :month => "11", 
         :day => "23",
         :permalink => 'blarf!'})
        @comment.should_receive(:save).and_return(true)
        post :create, :comment => {}, :blog_id => "1"
      end

      it "should redirect to the original post" do
        do_post
        response.should redirect_to('http://test.host/blogs/1/2008/11/23/blarf!')
      end

      it "should set comment user to current_user if logged in" do
        login_as :quentin
        stub!(:reset_session)
        @comment.should_receive(:user=).with(users(:quentin)).and_return(true)
        do_post
      end

    end


    describe "with failed save" do

      def do_post
        @comment.should_receive(:save).and_return(false)
        post :create, :comment => {}, :blog_id => "1"
      end

      it "should re-render 'new'" do
        do_post
        response.should render_template('new')
      end

    end
  end


  describe "handling GET for /blogs/1/posts/1/comments/1" do

    it "should be redirected to blog post comment anchor" do
      Comment.should_receive(:find).with("1", {:include=>{:post=>:blog}}).and_return(@comment)
      @comment.should_receive(:post).at_least(1).times.and_return(@post)      
      @post.should_receive(:permalink_url).and_return({:only_path => false, 
       :controller => "/posts", 
       :action => "permalink",  
       :blog_id => "1",
       :year => "2008", 
       :month => "11", 
       :day => "23",
       :permalink => 'blarf!',
       :anchor => "comment-#{@comment.id}"})
      get :show, :blog_id => "1", :post_id => "1", :id => "1"
      response.should redirect_to("http://test.host/blogs/1/2008/11/23/blarf!#comment-#{@comment.id}")
    end

  end


  describe "handling unsuccessful GET for /blogs/1/posts/1/comments/15155199" do

    it "should be redirected with flash message" do
      lambda {get :show, :blog_id => "1", :post_id => "1", :id => "15155199"}.should raise_error(ActiveRecord::RecordNotFound)
    end

  end

end
