require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TagsController do

  before(:each) do
    @blog = mock_model(Blog, :title => 'Blog Title')
    @post = mock_model(Post)
    @user = mock_model(User)
    @tag = mock_model(Tag)

    Blog.stub!(:find).and_return(@blog)
    Post.stub!(:find).and_return(@post)
    User.stub!(:find).and_return(@user)
    Tag.stub!(:find).and_return(@tag)
  end


  describe "handling GET blogs/1/tags" do

    def do_get
      get :index, :blog_id => "1"
    end

    it "should be successful, render index template and assign tags for the view" do
      @blog.should_receive(:tags).and_return(@tag)
      @tag.should_receive(:paginate).with(:all, {:include=>:taggings, :per_page=>10, :page=>nil, :order=>"name ASC"}).and_return([@tag])
      do_get
      response.should be_success
      response.should render_template('index')
      assigns[:tags].should == [@tag]
    end

  end


  describe "handling GET /blogs/1/users/1/tags" do
  
    def do_get
      get :index, :blog_id => "1", :user_id => "1"
    end
  
    it "should be successful, render index template and assign tags and user for the view" do
      @blog.should_receive(:tags).and_return(@tag)
      @tag.should_receive(:by_user).with(@user).and_return(@tag)
      @tag.should_receive(:paginate).with(:all, {:include=>:taggings, :per_page=>10, :page=>nil, :order=>"name ASC"}).and_return([@tag])
      do_get
      response.should be_success
      response.should render_template('index')
      assigns[:tags].should == [@tag]
    end
  
  end  

end
