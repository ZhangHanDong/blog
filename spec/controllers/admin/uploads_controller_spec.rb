require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Admin::UploadsController do

  fixtures :users

  before(:each) do
    login_as :quentin
    stub!(:reset_session)
    
    @blog = mock_model(Blog)
    Blog.stub!(:find).and_return(@blog)
  end

  describe "handling GET /uploads" do

    before(:each) do
      @upload = mock_model(Upload)
      @blog.should_receive(:uploads).and_return(@upload)
      Upload.stub!(:find).and_return([@upload])
      @upload.should_receive(:paginate).with({:include=>[:blog, :user], :per_page=>12, :page=>nil}).and_return([@upload])
    end

    def do_get
      get :index, :blog_id => "1"
    end

    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should render index template" do
      do_get
      response.should render_template('index')
    end

    it "should assign the found uploads for the view" do
      do_get
      assigns[:uploads].should == [@upload]
    end
  end

  describe "handling GET /uploads.xml" do

    before(:each) do
      @uploads = mock("Array of Uploads", :to_xml => "XML")
      @blog.should_receive(:uploads).and_return(@uploads)
      @uploads.should_receive(:recent).and_return(@uploads)
      Upload.stub!(:find).and_return(@uploads)
    end

    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :index, :blog_id => "1"
    end

    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should render the found uploads as xml" do
      @uploads.should_receive(:to_xml).and_return("XML")
      do_get
      response.body.should == "XML"
    end
  end

  describe "handling GET /uploads/1" do

    before(:each) do
      @upload = mock_model(Upload)
      @blog.should_receive(:uploads).and_return(@upload)
      @upload.should_receive(:find).with("1", :include => [:blog, :user]).and_return(@upload)
    end

    def do_get
      get :show, :id => "1", :blog_id => "1"
    end

    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should render show template" do
      do_get
      response.should render_template('show')
    end

    it "should assign the found upload for the view" do
      do_get
      assigns[:upload].should equal(@upload)
    end
  end

  describe "handling GET /uploads/1.xml" do

    before(:each) do
      @upload = mock_model(Upload, :to_xml => "XML")
      @blog.should_receive(:uploads).and_return(@upload)
      @upload.should_receive(:find).with("1", :include => [:blog, :user]).and_return(@upload)
    end

    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :show, :id => "1", :blog_id => "1"
    end

    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should render the found upload as xml" do
      @upload.should_receive(:to_xml).and_return("XML")
      do_get
      response.body.should == "XML"
    end
  end

  
  describe "handling POST /uploads" do

    before(:each) do
      @upload = mock_model(Upload, :to_param => "1")
      @blog.should_receive(:uploads).and_return(@upload)
      @upload.should_receive(:user=).with(users(:quentin)).and_return(true)
      @upload.should_receive(:<<)
      Upload.stub!(:new).and_return(@upload)
    end

    describe "with successful save" do

      def do_post
        @upload.should_receive(:save).and_return(true)
        post :create, :upload => {}, :blog_id => "1"
      end

      it "should create a new upload" do
        Upload.should_receive(:new).with({}).and_return(@upload)
        do_post
      end

      it "should redirect to the blog uploads" do
        do_post
        response.should redirect_to(admin_blog_uploads_url(@blog))
      end

    end

    describe "with failed save" do

      def do_post
        @upload.should_receive(:save).and_return(false)
        post :create, :upload => {}, :blog_id => "1"
      end

      it "should re-render 'new'" do
        do_post
        response.should render_template('admin/uploads/index')
      end

    end
  end

  
  describe "handling DELETE /uploads/1" do

    before(:each) do
      @upload = mock_model(Upload, :destroy => true)
      @upload.should_receive(:blog).and_return(@blog)
      Upload.stub!(:find).and_return(@upload)
    end

    def do_delete
      delete :destroy, :id => "1", :blog_id => "1"
    end

    it "should find the upload requested" do
      Upload.should_receive(:find).with("1", :include => :blog).and_return(@upload)
      do_delete
    end

    it "should call destroy on the found upload" do
      @upload.should_receive(:destroy)
      do_delete
    end

    it "should redirect to the uploads list" do
      do_delete
      response.should redirect_to(admin_blog_uploads_url(@blog))
    end
  end
end
