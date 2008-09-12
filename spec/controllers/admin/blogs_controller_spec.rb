require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Admin::BlogsController do

  fixtures :users

  before(:each) do
    login_as :quentin
    stub!(:reset_session)

    @blog   = mock_model(Blog, :title => 'blog 1', :in_draft => true, :shortname => 'blog1', :destroy => true)
    @blog_2 = mock_model(Blog, :title => 'blog 2', :in_draft => false, :shortname => 'blog_2')
    @user   = mock_model(User)
    @blogs  = mock("Array of Blogs", :to_xml => "XML")

    User.stub!(:find).and_return(@user)
    Blog.stub!(:find).and_return(@blog)
    Blog.stub!(:new).and_return(@blog)
  end


  describe "handling GET /blogs" do

    def do_get
      get :index
    end

    it "should be successful, render index template and find all blogs, assigning them for the view" do
      Blog.should_receive(:find).with(:all, {:offset => 0, :include => [:creator, :posts, :comments, :tags], :limit => 10 }).and_return([@blog, @blog_2])
      do_get
      response.should be_success
      response.should render_template('index')
      assigns[:blogs].should == [@blog, @blog_2]
    end

  end


  describe "handling GET /blogs.xml" do

    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :index
    end

    it "should be successful, find all blogs and render them as XML" do                                                                          
      Blog.stub!(:paginate).and_return(@blogs)
      do_get
      response.should be_success
      response.body.should == "XML"
    end
  end


  describe "handling GET /users/1/blogs" do

    before(:each) do
      User.stub!(:find).and_return(@user) 
    end

    def do_get
      get :index, :user_id => 1
    end

    it "should be successful, render index template and and find all blogs created by the user" do
      @user.should_receive(:created_blogs).and_return([@blog, @blog_2])
      do_get
      response.should be_success
      response.should render_template('index')  
      assigns[:user].should == @user
      assigns[:blogs].should == [@blog, @blog_2]
    end
  end


  describe "handling GET /users/1/blogs.xml" do

    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :index, :user_id => 1
    end

    it "should be successful, find all user blogs and render them as XML" do
      @user.should_receive(:created_blogs).and_return(@blogs)
      @blogs.stub!(:paginate).and_return(@blogs)
      do_get
      response.should be_success
      response.body.should == "XML"
    end
  end


  describe "handling GET /blogs/1" do

    def do_get
      get :show, :id => "1"
    end

    it "should be successful, render show template, find the blog requested, assign the found blog for the view" do
      Blog.should_receive(:find).with("1", {:include=>:creator}).and_return(@blog)
      do_get
      response.should be_success
      response.should render_template('show')
      assigns[:blog].should equal(@blog)
    end
  end


  describe "handling GET /blogs/1.xml" do

    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :show, :id => "1"
    end

    it "should be successful, find the blog and render it as XML" do
      Blog.should_receive(:find).with("1", {:include=>:creator}).and_return(@blog)
      @blog.should_receive(:to_xml).and_return("XML")
      do_get
      response.should be_success
      response.body.should == "XML"
    end
  end


  describe "handling unsuccessful GET for /admin/blogs/15155199" do

    it "should be redirected with flash message" do
      Blog.should_receive(:find).and_raise(ActiveRecord::RecordNotFound)
      get :show, :id => "15155199"
      response.should redirect_to(root_url)
      flash[:notice].should_not be_empty
    end

  end


  describe "handling GET /blogs/new" do

    def do_get
      get :new
    end

    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should render new template" do
      do_get
      response.should render_template('new')
    end

    it "should create an new blog" do
      Blog.should_receive(:new).and_return(@blog)
      do_get
    end

    it "should not save the new blog" do
      @blog.should_not_receive(:save)
      do_get
    end

    it "should assign the new blog for the view" do
      do_get
      assigns[:blog].should equal(@blog)
    end
  end


  describe "handling GET /blogs/1/edit" do

    def do_get
      get :edit, :id => "1"
    end

    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should render edit template" do
      do_get
      response.should render_template('edit')
    end

    it "should find the blog requested" do
      Blog.should_receive(:find).and_return(@blog)
      do_get
    end

    it "should assign the found Blog for the view" do
      do_get
      assigns[:blog].should equal(@blog)
    end
  end


  describe "handling POST /blogs" do

    describe "with successful save" do

      def do_post
        @blog.should_receive(:creator=).with(users(:quentin)).and_return(true)
        @blog.should_receive(:save).and_return(true)
        post :create, :blog => {}
      end

      it "should create a new blog" do
        Blog.should_receive(:new).with({}).and_return(@blog)
        do_post
      end

      it "should redirect to the new blog" do
        do_post
        response.should redirect_to(admin_blog_url(@blog))
      end

    end


    describe "with failed save" do

      def do_post
        @blog.should_receive(:creator=).with(users(:quentin)).and_return(true)
        @blog.should_receive(:save).and_return(false)
        post :create, :blog => {}
      end

      it "should re-render 'new'" do
        do_post
        response.should render_template('new')
      end

    end
  end


  describe "handling PUT /blogs/1" do

    describe "with successful update" do

      def do_put
        @blog.should_receive(:update_attributes).and_return(true)
        put :update, :id => "1"
      end

      it "should find the blog requested" do
        Blog.should_receive(:find).with("1").and_return(@blog)
        do_put
      end

      it "should update the found blog" do
        do_put
        assigns(:blog).should equal(@blog)
      end

      it "should assign the found blog for the view" do
        do_put
        assigns(:blog).should equal(@blog)
      end

      it "should redirect to the blog" do
        do_put
        response.should redirect_to(admin_blog_url(@blog))
      end

    end


    describe "with failed update" do

      def do_put
        @blog.should_receive(:update_attributes).and_return(false)
        put :update, :id => "1"
      end

      it "should re-render 'edit'" do
        do_put
        response.should render_template('edit')
      end

      it "should be render template with flash message on update RecordInvalid" do
        @blog.errors.stub!(:full_messages).and_return([])
        @blog.should_receive(:update_attributes).and_raise(ActiveRecord::RecordInvalid.new(@blog))
        post :update, :id => "1"
        flash[:notice].should_not be_empty
        response.should render_template('edit')
      end

    end
  end


  describe "handling DELETE /blogs/1" do

    def do_delete
      delete :destroy, :id => "1"
    end

    it "should find the blog requested" do
      Blog.should_receive(:find).with("1").and_return(@blog)
      do_delete
    end

    it "should call destroy on the found blog" do
      @blog.should_receive(:destroy)
      do_delete
    end

    it "should redirect to the blogs list" do
      do_delete
      response.should redirect_to(admin_blogs_url)
    end
  end

end
