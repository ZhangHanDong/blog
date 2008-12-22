require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UsersController do

  before(:each) do
    @blog = mock_model(Blog, :title => 'Blog Title')
    @user = mock_model(User)
    @post = mock_model(Post)
    @comment = mock_model(Comment)
    @tag = mock_model(Tag)
  end


  describe "handling GET blogs/1/users" do

    def do_get
      Blog.stub!(:find).and_return(@blog)  
      get :index, :blog_id => "1"
    end

    it "should be successful, render index template and assign users and blog for the view" do
      @blog.should_receive(:users).and_return(@user)
      @user.should_receive(:paginate).with({ :per_page => 10, 
                                             :page => nil,
                                             :order => "created_at DESC" }).and_return([@user])
      do_get
      response.should be_success
      response.should render_template('index')
      assigns[:blog].should == @blog
      assigns[:users].should == [@user]
    end
    
  end
  
  
  describe "handling GET blogs/1/users/1" do

    def do_get
      Blog.stub!(:find).and_return(@blog)  
      get :show, :blog_id => "1", :id => "1"
    end

    it "should be successful, render show template and assign user for the view" do
      @blog.should_receive(:users).and_return(@user) 
      @user.should_receive(:find).and_return(@user)
      
      @blog.should_receive(:posts).and_return(@post)
      @post.should_receive(:published).and_return(@post)
      @post.should_receive(:by_user).and_return(@post)      
      
      @blog.should_receive(:comments).and_return(@comment)
      @comment.should_receive(:published).and_return(@comment)
      @comment.should_receive(:by_user).and_return(@comment)
      
      do_get
      response.should be_success
      response.should render_template('show')
      assigns[:posts].should == @post
      assigns[:comments].should == @comment
      assigns[:user].should == @user
    end
    
  end
  
  
  describe "handling exceptions" do

    before(:each) do
      controller.use_rails_error_handling!
    end

    it "should render 404 for RecordNotFound on GET /blogs/1/users/15155199 " do
      User.stub!(:find).and_raise(ActiveRecord::RecordNotFound)
      get :show, :id => "15155199", :blog_id => "1"
      response.should render_template("#{RAILS_ROOT}/public/404.html")
    end
    
  end
  
end