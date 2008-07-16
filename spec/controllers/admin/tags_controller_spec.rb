require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Admin::TagsController do

  fixtures :users

  describe "handling GET /tags" do

    before(:each) do
      login_as :quentin
      stub!(:reset_session)
      @tag = mock_model(Tag)
      Tag.stub!(:find).and_return([@tag])
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

    it "should find all tags" do
      Tag.should_receive(:find).with(:all, {:offset => 0, :order => "name ASC", :limit => 10 }).and_return([@tag])
      do_get
    end

    it "should assign the found tags for the view" do
      do_get
      assigns[:tags].should == [@tag]
    end
  end

  describe "handling GET /tags.xml" do
  
    before(:each) do
      login_as :quentin
      stub!(:reset_session)
      @tags = mock("Array of Tags", :to_xml => "XML")
      Tag.stub!(:find).and_return(@tags)
    end
  
    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :index
    end
  
    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should find all tags" do
      Tag.should_receive(:find).with(:all).and_return(@tags)
      do_get
    end
  
    it "should render the found tags as xml" do
      @tags.should_receive(:to_xml).and_return("XML")
      do_get
      response.body.should == "XML"
    end
  end
     
  describe "handling GET /tags/1" do
  
    before(:each) do
      login_as :quentin
      stub!(:reset_session)
      @tag = mock_model(Tag)
      Tag.stub!(:find).and_return(@tag)
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
  
    it "should find the tag requested" do
      Tag.should_receive(:find).with("1", {:include=>{:taggings=>[:user, :taggable]}}).and_return(@tag)
      do_get
    end
  
    it "should assign the found tag for the view" do
      do_get
      assigns[:tag].should equal(@tag)
    end
  end  
  
  
  describe "handling unsuccessful GET for /tags/15155199" do
    before(:each) do
      login_as :quentin
      stub!(:reset_session)
    end

    it "should be redirected with flash message" do
      get :show, :id => "15155199"    
      response.should redirect_to(root_url)
      flash[:notice].should_not be_empty
    end
  end
  
  
  
  describe "handling GET /tags/1.xml" do
  
    before(:each) do
      login_as :quentin
      stub!(:reset_session)
      @tag = mock_model(Tag, :to_xml => "XML")
      Tag.stub!(:find).and_return(@tag)
    end
  
    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :show, :id => "1"
    end
  
    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should find the tag requested" do
      Tag.should_receive(:find).with("1", {:include=>{:taggings=>[:user, :taggable]}}).and_return(@tag)
      do_get
    end
  
    it "should render the found tag as xml" do
      @tag.should_receive(:to_xml).and_return("XML")
      do_get
      response.body.should == "XML"
    end
  end        

end
