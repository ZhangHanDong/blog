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
      @blog.should_receive(:paginate).with(:per_page => 10, :page => nil).and_return([@blog])
      do_get
      response.should be_success
      response.should render_template('index')
      assigns[:blogs].should == [@blog]
    end
    
  end


  describe "handling exceptions" do

    before(:each) do
      controller.use_rails_error_handling!
    end

    it "should render 404 for RecordNotFound on GET /blogs/15155199 " do
      Blog.stub!(:find).and_raise(ActiveRecord::RecordNotFound)
      get :show, :id => "15155199"
      response.should render_template("#{RAILS_ROOT}/public/404.html")
    end
    
  end

end