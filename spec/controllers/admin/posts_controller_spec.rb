require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Admin::PostsController do

  fixtures :users

  before(:each) do
    login_as :quentin
    stub!(:reset_session)

    @blog = mock_model(Blog, :title => 'Blog Title', :id => 1, :to_param => "1")
    @post = mock_model(Post, :to_xml => "XML", :to_param => "1", :destroy => true)
    @user = mock_model(User, :to_param => "1")  
    @tag = mock_model(Tag)
    @posts = mock("Array of Posts", :to_xml => "XML")
    Blog.stub!(:find).and_return(@blog)
    Post.stub!(:find).and_return(@post)
    User.stub!(:find).and_return(@user)
    Tag.stub!(:find).and_return(@tag)
    Post.stub!(:new).and_return(@post)
  end       
  
   
  describe "handling GET /admin/users/1/posts" do

    before(:each) do
      Post.stub!(:find).and_return([@post])
    end

    def do_get
      get :index, :user_id => "1"
    end

    it "should be successful, render index template, find all posts and assign for the view" do
      @user.should_receive(:posts).and_return(@post)
      @post.should_receive(:paginate).with(:all, {:include=>[:blog, :comments, :user, :tags], :per_page=>10, :page=>nil}).and_return([@post])
      do_get
      response.should be_success
      response.should render_template('index')
      assigns[:posts].should == [@post]
    end
  end
     
  
  describe "handling GET /admin/users/1/posts.xml" do

    before(:each) do
      Post.stub!(:find).and_return(@posts)
    end

    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :index, :user_id => "1"
    end

    it "should be successful, find all posts and render them as XML" do
      @user.should_receive(:posts).and_return(@post)
      @post.should_receive(:recent).and_return(@post)
      @post.should_receive(:find).with(:all).and_return(@posts)
      @posts.should_receive(:to_xml).and_return("XML")
      do_get
      response.should be_success
      response.body.should == "XML"
    end
  end
     

  describe "handling GET /admin/blogs/1/posts" do

    before(:each) do
      Post.stub!(:find).and_return([@post])
    end

    def do_get
      get :index, :blog_id => "1"
    end

    it "should be successful, render index template, find all posts and assign for the view" do
      @blog.should_receive(:posts).and_return(@post)
      @post.should_receive(:paginate).with(:all, {:include=>[:blog, :comments, :user, :tags], :per_page=>10, :page=>nil}).and_return([@post])
      do_get
      response.should be_success
      response.should render_template('index')
      assigns[:posts].should == [@post]
    end
  end
          

  describe "handling GET /admin/blogs/1/posts.xml" do

    before(:each) do
      Post.stub!(:find).and_return(@posts)
    end

    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :index, :blog_id => "1"
    end

    it "should be successful, find all posts and render them as XML" do
      @blog.should_receive(:posts).and_return(@post)
      @post.should_receive(:recent).and_return(@post)
      @post.should_receive(:find).with(:all).and_return(@posts)
      @posts.should_receive(:to_xml).and_return("XML")
      do_get
      response.should be_success
      response.body.should == "XML"
    end
  end 
  

  describe "handling GET /admin/blogs/1/users/1/posts" do

    before(:each) do
      Post.stub!(:find).and_return([@post])
    end

    def do_get
      get :index, :blog_id => "1", :user_id => "1"
    end

    it "should be successful, find the posts for the user and assign the user and posts for the view" do                                
      @blog.should_receive(:posts).and_return(@post) 
      @post.should_receive(:by_user).with(@user).and_return(@post) 
      @post.should_receive(:paginate).with(:all, {:include=>[:blog, :comments, :user, :tags], :page=>nil, :per_page=>10}).and_return([@post])
      do_get
      response.should be_success
      assigns[:user].should equal(@user)
    end
  end
  
  
  describe "handling GET /admin/blogs/1/tags/1/posts" do

    before(:each) do
      Post.stub!(:find).and_return([@post])        
    end

    def do_get
      get :index, :blog_id => "1", :tag_id => "1"
    end

    it "should be successful, find the posts for the user and assign the user and posts for the view" do                                
      @blog.should_receive(:posts).and_return(@post) 
      @post.should_receive(:with_tag).with(@tag).and_return(@post) 
      @post.should_receive(:paginate).with(:all, {:include=>[:blog, :comments, :user, :tags], :page=>nil, :per_page=>10}).and_return([@post])
      do_get
      response.should be_success
    end
  end


  describe "handling GET /admin/blogs/1/posts/1" do

    def do_get
      get :show, :id => "1", :blog_id => "1"
    end

    it "should be successful, render show template, find the post and assign for the view" do
      Post.should_receive(:find).with("1", {:include=>[:blog, :comments, :user, :tags]}).and_return(@post)
      do_get
      response.should be_success       
      response.should render_template('show')   
      assigns[:post].should equal(@post)
    end
  end


  describe "handling GET /admin/blogs/1/posts/1.xml" do

    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :show, :id => "1", :blog_id => "1"
    end

    it "should be successful, find the post, and render it as XML" do
      Post.should_receive(:find).with("1", {:include=>[:blog, :comments, :user, :tags]}).and_return(@post)
      @post.should_receive(:to_xml).and_return("XML")
      do_get
      response.should be_success
      response.body.should == "XML"
    end
  end   

  
  describe "handling unsuccessful GET for /admin/blogs/1/posts/15155199" do

    it "should be redirected with flash message" do
      Post.should_receive(:find).and_raise(ActiveRecord::RecordNotFound)
      get :show, :id => "15155199", :blog_id => "1"
      response.should redirect_to(root_url)
      flash[:notice].should_not be_empty
    end

  end


  describe "handling GET /admin/blogs/1/posts/new" do

    def do_get
      get :new, :blog_id => "1"
    end

    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should render new template" do
      do_get
      response.should render_template('new')
    end

    it "should create an new post" do
      Post.should_receive(:new).and_return(@post)
      do_get
    end

    it "should not save the new post" do
      @post.should_not_receive(:save)
      do_get
    end

    it "should assign the new post for the view" do
      do_get
      assigns[:post].should equal(@post)
    end
  end   
  

  describe "handling GET /admin/blogs/1/posts/1/edit" do

    def do_get
      get :edit, :id => "1", :blog_id => "1"
    end

    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should render edit template" do
      do_get
      response.should render_template('edit')
    end

    it "should find the post requested" do
      Post.should_receive(:find).and_return(@post)
      do_get
    end

    it "should assign the found Post for the view" do
      do_get
      assigns[:post].should equal(@post)
    end
  end   
  

  describe "handling POST /admin/blogs/1/posts" do

    describe "with setting author (user) (successful save)" do

      def do_post
        @blog.should_receive(:posts).and_return([@post])
        @post.should_receive(:user=).with(users(:quentin)).and_return(true)
        @post.should_receive(:save).and_return(true)
        post :create, :post => {}, :blog_id => "1"
      end

      it "should create a new post with the correct author set" do
        Post.should_receive(:new).with({}).and_return(@post)
        do_post
      end

      it "should redirect to the new post" do
        do_post
        response.should redirect_to(admin_blog_post_url("1", "1"))
      end

    end

    describe "with failed save" do

      def do_post
        @blog.should_receive(:posts).and_return([@post])
        @post.should_receive(:user=).with(users(:quentin)).and_return(true)
        @post.should_receive(:save).and_return(false)
        post :create, :post => {}, :blog_id => "1"
      end

      it "should re-render 'new'" do
        do_post
        response.should render_template('new')
      end

    end
  end 
  

  describe "handling PUT /admin/blogs/1/posts/1" do

    describe "with successful update" do

      def do_put
        @post.should_receive(:blog).and_return(@blog)
        @post.should_receive(:update_attributes).and_return(true)
        put :update, :id => "1", :blog_id => "1"
      end

      it "should find the post requested" do
        Post.should_receive(:find).with("1", {:include=>:blog}).and_return(@post)
        do_put
      end

      it "should update the found post" do
        do_put
        assigns(:post).should equal(@post)
      end

      it "should assign the found post for the view" do
        do_put
        assigns(:post).should equal(@post)
      end

      it "should redirect to the post" do
        do_put
        response.should redirect_to(admin_blog_post_url("1", "1"))
      end

    end

    describe "with failed update" do

      def do_put
        @post.should_receive(:update_attributes).and_return(false)
        put :update, :id => "1", :blog_id => "1"
      end

      it "should re-render 'edit'" do
        do_put
        response.should render_template('edit')
      end

      it "should be render template with flash message on update RecordInvalid" do
        @post.errors.stub!(:full_messages).and_return([])
        @post.should_receive(:update_attributes).and_raise(ActiveRecord::RecordInvalid.new(@post))
        post :update, :id => "1"
        flash[:notice].should_not be_empty
        response.should render_template('edit')
      end

    end
  end
        

  describe "handling DELETE /admin/blogs/1/posts/1" do

    def do_delete
      @post.should_receive(:blog).and_return(@blog)
      delete :destroy, :id => "1", :blog_id => "1"
    end

    it "should find the post requested" do
      Post.should_receive(:find).with("1", {:include=>:blog}).and_return(@post)
      do_delete
    end

    it "should call destroy on the found post" do
      @post.should_receive(:destroy)
      do_delete
    end

    it "should redirect to the posts list" do
      do_delete
      response.should redirect_to(admin_blog_posts_url("1"))
    end
  end
end
