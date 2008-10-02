require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Admin::UploadsController do

  fixtures :users

  before(:each) do
    login_as :quentin
    stub!(:reset_session)
  end

  describe "handling GET /uploads" do

    before(:each) do
      @upload = mock_model(Upload)
      Upload.stub!(:find).and_return([@upload])
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

    it "should find all uploads" do
      Upload.should_receive(:find).with(:all).and_return([@upload])
      do_get
    end

    it "should assign the found uploads for the view" do
      do_get
      assigns[:uploads].should == [@upload]
    end
  end

  describe "handling GET /uploads.xml" do

    before(:each) do
      @uploads = mock("Array of Uploads", :to_xml => "XML")
      Upload.stub!(:find).and_return(@uploads)
    end

    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :index
    end

    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should find all uploads" do
      Upload.should_receive(:find).with(:all).and_return(@uploads)
      do_get
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
      Upload.stub!(:find).and_return(@upload)
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

    it "should find the upload requested" do
      Upload.should_receive(:find).with("1").and_return(@upload)
      do_get
    end

    it "should assign the found upload for the view" do
      do_get
      assigns[:upload].should equal(@upload)
    end
  end

  describe "handling GET /uploads/1.xml" do

    before(:each) do
      @upload = mock_model(Upload, :to_xml => "XML")
      Upload.stub!(:find).and_return(@upload)
    end

    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :show, :id => "1"
    end

    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should find the upload requested" do
      Upload.should_receive(:find).with("1").and_return(@upload)
      do_get
    end

    it "should render the found upload as xml" do
      @upload.should_receive(:to_xml).and_return("XML")
      do_get
      response.body.should == "XML"
    end
  end

  describe "handling GET /uploads/new" do

    before(:each) do
      @upload = mock_model(Upload)
      Upload.stub!(:new).and_return(@upload)
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

    it "should create an new upload" do
      Upload.should_receive(:new).and_return(@upload)
      do_get
    end

    it "should not save the new upload" do
      @upload.should_not_receive(:save)
      do_get
    end

    it "should assign the new upload for the view" do
      do_get
      assigns[:upload].should equal(@upload)
    end
  end

  describe "handling GET /uploads/1/edit" do

    before(:each) do
      @upload = mock_model(Upload)
      Upload.stub!(:find).and_return(@upload)
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

    it "should find the upload requested" do
      Upload.should_receive(:find).and_return(@upload)
      do_get
    end

    it "should assign the found Upload for the view" do
      do_get
      assigns[:upload].should equal(@upload)
    end
  end

  describe "handling POST /uploads" do

    before(:each) do
      @upload = mock_model(Upload, :to_param => "1")
      Upload.stub!(:new).and_return(@upload)
    end

    describe "with successful save" do

      def do_post
        @upload.should_receive(:save).and_return(true)
        post :create, :upload => {}
      end

      it "should create a new upload" do
        Upload.should_receive(:new).with({}).and_return(@upload)
        do_post
      end

      it "should redirect to the new upload" do
        do_post
        response.should redirect_to(admin_upload_url("1"))
      end

    end

    describe "with failed save" do

      def do_post
        @upload.should_receive(:save).and_return(false)
        post :create, :upload => {}
      end

      it "should re-render 'new'" do
        do_post
        response.should render_template('new')
      end

    end
  end

  describe "handling PUT /uploads/1" do

    before(:each) do
      @upload = mock_model(Upload, :to_param => "1")
      Upload.stub!(:find).and_return(@upload)
    end

    describe "with successful update" do

      def do_put
        @upload.should_receive(:update_attributes).and_return(true)
        put :update, :id => "1"
      end

      it "should find the upload requested" do
        Upload.should_receive(:find).with("1").and_return(@upload)
        do_put
      end

      it "should update the found upload" do
        do_put
        assigns(:upload).should equal(@upload)
      end

      it "should assign the found upload for the view" do
        do_put
        assigns(:upload).should equal(@upload)
      end

      it "should redirect to the upload" do
        do_put
        response.should redirect_to(admin_upload_url("1"))
      end

    end

    describe "with failed update" do

      def do_put
        @upload.should_receive(:update_attributes).and_return(false)
        put :update, :id => "1"
      end

      it "should re-render 'edit'" do
        do_put
        response.should render_template('edit')
      end

    end
  end

  describe "handling DELETE /uploads/1" do

    before(:each) do
      @upload = mock_model(Upload, :destroy => true)
      Upload.stub!(:find).and_return(@upload)
    end

    def do_delete
      delete :destroy, :id => "1"
    end

    it "should find the upload requested" do
      Upload.should_receive(:find).with("1").and_return(@upload)
      do_delete
    end

    it "should call destroy on the found upload" do
      @upload.should_receive(:destroy)
      do_delete
    end

    it "should redirect to the uploads list" do
      do_delete
      response.should redirect_to(admin_uploads_url)
    end
  end
end
