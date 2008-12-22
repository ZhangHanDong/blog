require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Admin::BlogsController do

  fixtures :users

  before(:each) do
    login_as :quentin
    stub!(:reset_session)

    @user   = mock_model(User)
    @blogs  = mock("Array of Blogs", :to_xml => "XML")
    @blog   = mock_model(Blog, :title => 'blog 1', :in_draft => true,
                               :shortname => 'blog1', :destroy => true)
    
    Blog.stub!(:find).and_return(@blog)
    Blog.stub!(:new).and_return(@blog)
  end


  describe "handling GET /blogs" do

    def do_get
      get :index
    end

    it "should be successful, render index template and find all blogs, \
        assigning them for the view" do
      @blog.should_receive(:paginate).with({ :page => nil,
                                             :include => [:creator, :posts, :comments, :tags],
                                             :per_page => 10 }).and_return([@blog])
      do_get
      response.should be_success
      response.should render_template('index')
      assigns[:blogs].should == [@blog]
    end

  end


  describe "handling GET /blogs.xml" do

    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :index
    end

    it "should be successful, find all blogs and render them as XML" do
      Blog.stub!(:find).and_return(@blogs)
      @blogs.should_receive(:recent).and_return(@blogs)
      do_get
      response.should be_success
      response.body.should == "XML"
    end
    
  end


  describe "handling GET /users/1/blogs" do

    def do_get
      get :index, :user_id => 1
    end

    it "should be successful, render index template and and find all blogs created by the user" do
      User.stub!(:find).and_return(@user)
      @user.should_receive(:created_blogs).and_return(@blog)
      @blog.should_receive(:paginate).with({ :include => [:creator, :posts, :comments, :tags],
                                             :page => nil, :per_page => 10 }).and_return([@blog])
      do_get
      response.should be_success
      response.should render_template('index')
      assigns[:user].should == @user
      assigns[:blogs].should == [@blog]
    end
    
  end


  describe "handling GET /blogs/1" do

    def do_get
      get :show, :id => "1"
    end

    it "should be successful, render show template, find the blog requested, \ 
        assign the found blog for the view" do
      Blog.should_receive(:find).with("1", { :include => :creator }).and_return(@blog)
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
      Blog.should_receive(:find).with("1", { :include => :creator }).and_return(@blog)
      @blog.should_receive(:to_xml).and_return("XML")
      do_get
      response.should be_success
      response.body.should == "XML"
    end
    
  end


  describe "handling GET /blogs/new" do

    def do_get
      get :new
    end

    it "should be successful, render new template assign for new blog for the view" do
      Blog.should_receive(:new).and_return(@blog)
      do_get
      response.should be_success
      response.should render_template('new')
      assigns[:blog].should equal(@blog)
    end

    it "should not save the new blog" do
      @blog.should_not_receive(:save)
      do_get
    end

  end


  describe "handling GET /blogs/1/edit" do

    def do_get
      get :edit, :id => "1"
    end

    it "should be successful, find blog, render edit template and assign for the view" do
      Blog.should_receive(:find).and_return(@blog)
      do_get
      response.should be_success
      response.should render_template('edit')
      assigns[:blog].should equal(@blog)
    end

  end


  describe "handling POST /blogs" do

    describe "with successful create" do

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


    describe "with failed create" do

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

      it "should find the blog requested, update it and redirect to the blog" do
        Blog.should_receive(:find).with("1").and_return(@blog)
        do_put
        response.should redirect_to(admin_blog_url(@blog))
      end

    end

    describe "with failed update" do

      def do_put
        @blog.should_receive(:update_attributes).and_return(false)
        put :update, :id => "1"
      end

      it "should find the blog requested, update it and redirect to the blog" do
        Blog.should_receive(:find).with("1").and_return(@blog)
        do_put
        response.should render_template('edit')
      end

    end

  end


  describe "handling DELETE /blogs/1" do

    def do_delete
      delete :destroy, :id => "1"
    end

    it "should find the blog requested, call destroy and redirect to the blogs list" do
      Blog.should_receive(:find).with("1").and_return(@blog)
      @blog.should_receive(:destroy)
      do_delete
      response.should redirect_to(admin_blogs_url)
    end

  end


  describe "handling exceptions" do

    before(:each) do
      controller.use_rails_error_handling!
    end

    it "should render 404 for RecordNotFound on GET /admin/blogs/15155199 " do
      Blog.stub!(:find).and_raise(ActiveRecord::RecordNotFound)
      get :show, :id => "15155199"
      response.should render_template("#{RAILS_ROOT}/public/404.html")
    end
    
    it "should show flash message and re-render action view on failed create" do
      blog = mock("Blog")
      errors = mock("errors")

      blog.stub!(:errors).and_return(errors)
      blog.stub!(:new_record?).and_return(true)
      errors.stub!(:full_messages).and_return([]) 
      Blog.should_receive(:new).and_raise(ActiveRecord::RecordInvalid.new(blog))
      
      post :create, :blog => {}
      
      response.should render_template('new')
      flash[:notice].should eql('Sorry, there was a problem creating that')
    end
    
    it "should show flash message and re-render action view on failed update" do
      blog = mock("Blog")
      errors = mock("errors")

      blog.stub!(:errors).and_return(errors)
      blog.stub!(:new_record?).and_return(false)
      errors.stub!(:full_messages).and_return([]) 
      Blog.should_receive(:new).and_raise(ActiveRecord::RecordInvalid.new(blog))
      
      post :create, :blog => {}
      
      response.should render_template('edit')
      flash[:notice].should eql('Sorry, there was a problem updating that')
    end
    
  end

end