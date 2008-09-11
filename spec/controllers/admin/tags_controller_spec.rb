require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Admin::TagsController do

  fixtures :users

   before(:each) do
     login_as :quentin
     stub!(:reset_session)

     @blog = mock_model(Blog, :title => 'Blog Title')
     @user = mock_model(User)
     @tag = mock_model(Tag, :to_xml => "XML")
     @tags = mock("Array of Tags", :to_xml => "XML")
     Blog.stub!(:find).and_return(@blog)
     User.stub!(:find).and_return(@user)
     Tag.stub!(:find).and_return([@tag])
   end


  describe "handling GET /admin/blogs/1/tags" do

    def do_get
      get :index, :blog_id => "1"
    end

    it "should be successful, render index template, find all tags and assign them for the view" do
      @blog.should_receive(:tags).and_return(@tag)
      @tag.should_receive(:paginate).with(:all, {:include=>:taggings, :page=>nil, :order=>"name ASC", :per_page=>10}).and_return([@tag])
      do_get
      response.should be_success
      response.should render_template('index')
      assigns[:tags].should == [@tag]
    end

  end


  describe "handling GET /admin/blogs/1/tags.xml" do

    before(:each) do
      Tag.stub!(:find).and_return(@tags)
      @request.env["HTTP_ACCEPT"] = "application/xml"
    end

    def do_get
      get :index, :blog_id => "1"
    end

    it "should be successful, find all tags and render them as XML" do
      @blog.should_receive(:tags).and_return(@tags)
      @tags.should_receive(:to_xml).and_return("XML")
      do_get
      response.should be_success
      response.body.should == "XML"
    end

  end


  describe "handling GET /admin/blogs/1/users/1/tags" do

    def do_get
      get :index, :blog_id => "1", :user_id => "1"
    end

    it "should be successful, render index template, find all tags for the user and assign them for the view" do
      @blog.should_receive(:tags).and_return(@tags)
      @tags.should_receive(:by_user).with(@user).and_return(@tags)
      @tags.should_receive(:paginate).with(:all, {:include=>:taggings, :page=>nil, :order=>"name ASC", :per_page=>10}).and_return([@tag])
      do_get
      response.should be_success
      response.should render_template('index')
      assigns[:tags].should == [@tag]
    end

  end


  describe "handling GET /admin/blogs/1/users/1/tags.xml" do

    before(:each) do
      @request.env["HTTP_ACCEPT"] = "application/xml"
    end

    def do_get
      get :index, :blog_id => "1", :user_id => "1"
    end

    it "should be successful, find all tags for the user and render them as XML" do
      @blog.should_receive(:tags).and_return(@tags)
      @tags.should_receive(:by_user).with(@user).and_return(@tags)
      do_get
      response.should be_success
      response.body.should == "XML"
    end

  end


  describe "handling GET /admin/blogs/1/tags/1" do

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

    it "should find the tag requested" do
      Tag.should_receive(:find).with("1", {:include=>:taggings, :conditions=>["taggings.blog_id = ?", @blog.id]}).and_return(@tag)
      do_get
    end

    it "should assign the found tag for the view" do
      Tag.stub!(:find).and_return(@tag)
      do_get
      assigns[:tag].should equal(@tag)
    end
  end


  describe "handling unsuccessful GET for /admin/blogs/1/tags/15155199" do

    it "should be redirected with flash message" do
      Tag.should_receive(:find).and_raise(ActiveRecord::RecordNotFound)
      get :show, :id => "15155199"
      response.should redirect_to(root_url)
      flash[:notice].should_not be_empty
    end

  end


  describe "handling GET /admin/blogs/1/tags/1.xml" do

    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :show, :id => "1", :blog_id => "1"
    end

    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should find the tag requested" do
      Tag.should_receive(:find).with("1", {:include=>:taggings, :conditions=>["taggings.blog_id = ?", @blog.id]}).and_return(@tag)
      do_get
    end

    it "should render the found tag as xml" do
      Tag.stub!(:find).and_return(@tag)
      @tag.should_receive(:to_xml).and_return("XML")
      do_get
      response.body.should == "XML"
    end
  end

end
