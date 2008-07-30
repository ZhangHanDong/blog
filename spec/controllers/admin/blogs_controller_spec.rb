require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Admin::BlogsController do       
  
  fixtures :users 
  
  describe "handling GET /blogs" do

    before(:each) do            
      login_as :quentin
      stub!(:reset_session)
      @blog = mock_model(Blog)
      Blog.stub!(:find).and_return([@blog])
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
  
    it "should find all blogs" do
      Blog.should_receive(:find).with(:all).and_return([@blog])
      do_get
    end
  
    it "should assign the found blogs for the view" do
      do_get
      assigns[:blogs].should == [@blog]
    end
  end

  describe "handling GET /blogs.xml" do

    before(:each) do       
      login_as :quentin
      stub!(:reset_session)
      @blogs = mock("Array of Blogs", :to_xml => "XML")
      Blog.stub!(:find).and_return(@blogs)
    end
  
    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :index
    end
  
    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should find all blogs" do
      Blog.should_receive(:find).with(:all).and_return(@blogs)
      do_get
    end
  
    it "should render the found blogs as xml" do
      @blogs.should_receive(:to_xml).and_return("XML")
      do_get
      response.body.should == "XML"
    end
  end

  describe "handling GET /blogs/1" do

    before(:each) do           
      login_as :quentin
      stub!(:reset_session)
      @blog = mock_model(Blog)
      Blog.stub!(:find).and_return(@blog)
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
  
    it "should find the blog requested" do
      Blog.should_receive(:find).with("1").and_return(@blog)
      do_get
    end
  
    it "should assign the found blog for the view" do
      do_get
      assigns[:blog].should equal(@blog)
    end
  end

  describe "handling GET /blogs/1.xml" do

    before(:each) do    
      login_as :quentin
      stub!(:reset_session)
      @blog = mock_model(Blog, :to_xml => "XML")
      Blog.stub!(:find).and_return(@blog)
    end
  
    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :show, :id => "1"
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should find the blog requested" do
      Blog.should_receive(:find).with("1").and_return(@blog)
      do_get
    end
  
    it "should render the found blog as xml" do
      @blog.should_receive(:to_xml).and_return("XML")
      do_get
      response.body.should == "XML"
    end
  end

  describe "handling GET /blogs/new" do

    before(:each) do         
      login_as :quentin
      stub!(:reset_session)
      @blog = mock_model(Blog)
      Blog.stub!(:new).and_return(@blog)
    end
  
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

    before(:each) do   
      login_as :quentin
      stub!(:reset_session)
      @blog = mock_model(Blog)
      Blog.stub!(:find).and_return(@blog)
    end
  
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

    before(:each) do     
      login_as :quentin
      stub!(:reset_session)
      @blog = mock_model(Blog, :to_param => "1")
      Blog.stub!(:new).and_return(@blog)
    end
    
    describe "with successful save" do
  
      def do_post
        @blog.should_receive(:save).and_return(true)
        post :create, :blog => {}
      end
  
      it "should create a new blog" do
        Blog.should_receive(:new).with({}).and_return(@blog)
        do_post
      end

      it "should redirect to the new blog" do
        do_post
        response.should redirect_to(admin_blog_url("1"))
      end
      
    end
    
    describe "with failed save" do

      def do_post
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

    before(:each) do   
      login_as :quentin
      stub!(:reset_session)
      @blog = mock_model(Blog, :to_param => "1")
      Blog.stub!(:find).and_return(@blog)
    end
    
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
        response.should redirect_to(admin_blog_url("1"))
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

    before(:each) do 
      login_as :quentin
      stub!(:reset_session)
      @blog = mock_model(Blog, :destroy => true)
      Blog.stub!(:find).and_return(@blog)
    end
  
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
