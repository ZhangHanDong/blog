require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Admin::TagsController do

  fixtures :users

  before(:each) do
    login_as :quentin
    stub!(:reset_session)

    @blog = mock_model(Blog, :title => 'Blog Title')
    @user = mock_model(User)
    @tag = mock_model(Tag)
    @tags = mock("Array of Tags", :to_xml => "XML")

    Blog.stub!(:find).and_return(@blog)
    User.stub!(:find).and_return(@user)
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
      assigns[:blog].should == @blog 
      assigns[:tags].should == [@tag]
    end

  end


  describe "handling GET /admin/blogs/1/tags.xml" do

    def do_get             
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :index, :blog_id => "1"
    end

    it "should be successful, find all tags and render them as XML" do
      @blog.should_receive(:tags).and_return(@tags) 
      @tags.should_receive(:recent).and_return(@tags) 
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
      assigns[:blog].should == @blog
      assigns[:user].should == @user
      assigns[:tags].should == [@tag]
    end

  end


  describe "handling GET /admin/blogs/1/users/1/tags.xml" do

    def do_get                           
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :index, :blog_id => "1", :user_id => "1"
    end

    it "should be successful, find all tags for the user and render them as XML" do
      @blog.should_receive(:tags).and_return(@tags)
      @tags.should_receive(:by_user).with(@user).and_return(@tags)
      @tags.should_receive(:recent).and_return(@tags)
      do_get
      response.should be_success
      response.body.should == "XML"
    end

  end


  describe "handling GET /admin/blogs/1/tags/1" do

    def do_get
      get :show, :id => "1", :blog_id => "1"
    end

    it "should be successful, render show template, find the tag requested and assign for the view" do        
      Tag.should_receive(:find).with("1", {:include=>:taggings, :conditions=>["taggings.blog_id = ?", @blog.id]}).and_return(@tag)  
      do_get
      response.should be_success  
      response.should render_template('show')  
      assigns[:tag].should equal(@tag)       
    end
  end


  describe "handling unsuccessful GET for /admin/blogs/1/tags/15155199" do

    it "should be redirected with flash message" do
      lambda {get :show, :id => "15155199"}.should raise_error(ActiveRecord::RecordNotFound)
    end

  end


  describe "handling GET /admin/blogs/1/tags/1.xml" do

    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :show, :id => "1", :blog_id => "1"
    end

    it "should be successful, find the tag and return it as XML" do
      Tag.should_receive(:find).with("1", {:include=>:taggings, :conditions=>["taggings.blog_id = ?", @blog.id]}).and_return(@tag)
      @tag.should_receive(:to_xml).and_return("XML")
      do_get
      response.should be_success
      response.body.should == "XML"
    end
  end

end
