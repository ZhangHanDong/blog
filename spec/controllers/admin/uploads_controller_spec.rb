require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Admin::UploadsController do

  fixtures :users

  before(:each) do
    login_as :quentin
    stub!(:reset_session)
    
    @blog = mock_model(Blog)
    @user = mock_model(User)
    Blog.stub!(:find).and_return(@blog)
  end
  

  describe "handling GET /admin/blogs/1/uploads" do

    before(:each) do
      @upload = mock_model(Upload)
      @blog.should_receive(:uploads).and_return(@upload)
      Upload.stub!(:find).and_return([@upload])
      @upload.should_receive(:paginate).with({ :include => [:blog, :user], 
                                               :per_page => 12, :page => nil }).and_return([@upload])
    end

    def do_get
      get :index, :blog_id => "1"
    end

    it "should be successful, render index template and assign uploads for the view" do
      do_get
      response.should be_success
      response.should render_template('index')
      assigns[:uploads].should == [@upload]
    end

  end


  describe "handling GET /admin/blogs/1/uploads.xml" do

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

    it "should be successful and render the found uploads as xml" do
      @uploads.should_receive(:to_xml).and_return("XML")
      do_get
      response.should be_success
      response.body.should == "XML"
    end

  end
  
  
  describe "handling GET /admin/blogs/1/users/1/uploads" do

    before(:each) do
      @upload = mock_model(Upload)
      User.stub!(:find).and_return(@user)
      Upload.stub!(:find).and_return(@upload)
      
      @blog.should_receive(:uploads).and_return(@upload)
      @upload.should_receive(:by_user).with(@user).and_return(@upload)
      @upload.should_receive(:paginate).with({ :include => [:blog, :user], 
                                               :per_page => 12, :page => nil }).and_return([@upload])
    end

    def do_get
      get :index, :blog_id => "1", :user_id => "1"
    end

    it "should be successful, render index template and assign uploads for the view" do
      do_get
      response.should be_success
      response.should render_template('index')
      assigns[:uploads].should == [@upload]
      assigns[:user].should == @user
    end

  end


  describe "handling GET /admin/blogs/1/uploads/1" do

    before(:each) do
      @upload = mock_model(Upload)
      @blog.should_receive(:uploads).and_return(@upload)
      @upload.should_receive(:find).with("1", :include => [:blog, :user]).and_return(@upload)
    end

    def do_get
      get :show, :id => "1", :blog_id => "1"
    end

    it "should be successful, render show template and assign the found upload for the view" do
      do_get
      response.should be_success
      response.should render_template('show')
      assigns[:upload].should equal(@upload)
    end

  end


  describe "handling GET /admin/blogs/1/uploads/1.xml" do

    before(:each) do
      @upload = mock_model(Upload, :to_xml => "XML")
      @blog.should_receive(:uploads).and_return(@upload)
      @upload.should_receive(:find).with("1", :include => [:blog, :user]).and_return(@upload)
    end

    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :show, :id => "1", :blog_id => "1"
    end

    it "should be successful and render the found upload as xml" do
      @upload.should_receive(:to_xml).and_return("XML")
      do_get
      response.should be_success
      response.body.should == "XML"
    end

  end

  
  describe "handling POST /admin/blogs/1/uploads" do

    before(:each) do
      @upload = mock_model(Upload, :to_param => "1")
      @upload.should_receive(:user=).with(users(:quentin)).and_return(true)
      @upload.should_receive(:<<)
      Upload.stub!(:new).and_return(@upload)
    end
    
    describe "performing successful upload with test file" do
      
      def do_post
        @blog.should_receive(:uploads).and_return(@upload)
        @upload.should_receive(:save).and_return(true)
        post :create, :upload => fixture_file_upload('files/50x50.png', 'image/png'),
             :blog_id => "1"
      end
      
      it "should upload file successfully and redirect to blog uploads" do
        Upload.should_receive(:new).with(anything()).and_return(@upload)
        do_post
        response.should redirect_to(admin_blog_uploads_url(@blog))
      end
      
    end

    describe "performing failed upload with test file" do

      def do_post
        @blog.should_receive(:uploads).twice.and_return(@upload)
        @upload.should_receive(:save).and_return(false)
        @upload.should_receive(:paginate).with({ :include => [:blog, :user],
                                                 :per_page => 12, :page => nil }).and_return([@upload])
        post :create, :upload => fixture_file_upload('files/50x50.png', 'image/png'),
             :blog_id => "1"
      end

      it "should re-render 'new'" do
        do_post
        response.should render_template('admin/uploads/index')
      end

    end
    
  end

  
  describe "handling DELETE /admin/blogs/1/uploads/1" do

    before(:each) do
      @upload = mock_model(Upload, :destroy => true)
      @upload.should_receive(:blog).and_return(@blog)
      Upload.stub!(:find).and_return(@upload)
    end

    def do_delete
      delete :destroy, :id => "1", :blog_id => "1"
    end

    it "should find the upload requested, call destroy and redirect to uploads list" do
      Upload.should_receive(:find).with("1", :include => :blog).and_return(@upload)
      @upload.should_receive(:destroy)
      do_delete
      response.should redirect_to(admin_blog_uploads_url(@blog))
    end
    
  end 
     
  
  describe "handling exceptions" do

    before(:each) do
      controller.use_rails_error_handling!
    end

    it "should render 404 for RecordNotFound on GET /admin/blogs/1/uploads/15155199 " do
      Blog.stub!(:find).and_raise(ActiveRecord::RecordNotFound)
      get :show, :id => "15155199", :blog_id => "1"
      response.should render_template("#{RAILS_ROOT}/public/404.html")
    end
    
  end

end