require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe BlogsController do

  before(:each) do
    @blog = mock_model(Blog)
  end
         

  describe "handling GET /blogs" do

    def do_get
      get :index
    end

    it "should be successful, find blogs, render index and assign blogs for the view" do
      Blog.should_receive(:published).and_return(@blog)
      @blog.should_receive(:paginate).with(:per_page=>10, :page=>nil).and_return([@blog])
      do_get
      response.should be_success
      response.should render_template('index')
      assigns[:blogs].should == [@blog]
    end
  end


  describe "handling GET /blogs/1" do

    def do_get            
      get :show, :id => "1"
    end

    it "should be successful, find and assign the blog and redirect to blog posts url" do
      Blog.should_receive(:find).with("1").and_return(@blog)
      do_get                                                                
      assigns[:blog].should equal(@blog)
      response.should redirect_to(blog_posts_url(@blog))
    end            
  end


  describe "handling unsuccessful GET for /blogs/15155199" do
    it "should be redirected with flash message" do
      lambda {get :show, :id => "15155199"}.should raise_error(ActiveRecord::RecordNotFound)
    end
  end

end
