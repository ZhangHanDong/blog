require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PostsController do

  before(:each) do
    @blog = mock_model(Blog, :title => 'Blog Title')
    @post = mock_model(Post, :to_xml => "XML")
    @user = mock_model(User)
    @tag = mock_model(Tag)

    Blog.stub!(:find).and_return(@blog)
    Post.stub!(:find).and_return(@post)
    User.stub!(:find).and_return(@user)
    Tag.stub!(:find).and_return(@tag)
  end


  describe "handling GET blogs/1/posts" do

    def do_get
      get :index, :blog_id => "1"
    end

    it "should be successful, render index template and assign blog and posts for the view" do
      @blog.should_receive(:posts).and_return(@post)
      @post.should_receive(:published).and_return(@post)
      @post.should_receive(:paginate).with({ :include => [:comments, :user, :tags],
                                             :per_page => 10, :page => nil }).and_return([@post])
      do_get
      
      response.should be_success
      response.should render_template('index')
      assigns[:blog].should == @blog
      assigns[:posts].should == [@post]
    end

  end


  describe "handling GET /blogs/1/posts.atom" do

    def do_get
      @request.env["HTTP_ACCEPT"] = "application/atom+xml"
      get :index, :blog_id => "1"
    end

    it "should be successful" do
      @blog.should_receive(:posts).and_return(@post)
      @post.should_receive(:published).and_return(@post)
      @post.should_receive(:recent).and_return([@post])
      do_get
      
      response.should be_success
      response.should render_template('index')
      assigns[:blog].should == @blog
      assigns[:posts].should == [@post]
    end

  end


  describe "handling GET /blogs/1/users/1/posts" do

    def do_get
      get :index, :blog_id => "1", :user_id => "1"
    end

    it "should be successful, render index template and assign posts and user for the view" do
      @blog.should_receive(:posts).and_return(@post)
      @post.should_receive(:published).and_return(@post)
      @post.should_receive(:by_user).with(@user).and_return(@post)
      @post.should_receive(:paginate).with({ :include => [:comments, :user, :tags], 
                                             :per_page => 10, :page => nil }).and_return([@post])
                                            
      do_get
      response.should be_success
      response.should render_template('index')
      assigns[:blog].should == @blog
      assigns[:user].should equal(@user)
      assigns[:posts].should == [@post]
    end

  end


  describe "handling GET /blogs/1/tags/1/posts" do

    def do_get
      get :index, :blog_id => "1", :tag_id => "1"
    end

    it "should be successful and assign the found tag and posts for the view" do
      @blog.should_receive(:posts).and_return(@post)
      @post.should_receive(:published).and_return(@post)
      @post.should_receive(:with_tag).with(@tag).and_return(@post)
      @post.should_receive(:paginate).with({ :include => [:comments, :user, :tags],
                                             :per_page => 10, :page => nil }).and_return([@post])
      do_get
      response.should be_success
      assigns[:blog].should == @blog
      assigns[:tag].should equal(@tag)
      assigns[:posts].should == [@post]
    end

  end


  describe "handling GET /blogs/1/on with date range" do

    before(:each) do
      @blog.should_receive(:posts).and_return(@post)
      @post.should_receive(:published).and_return(@post)
    end

    it "should be successful on year search" do
      @post.should_receive(:paginate).with({ :include => [:comments, :user, :tags], 
                                             :per_page => 10, :page => nil }).and_return([@post])
      @post.should_receive(:in_range).with(Time.utc(2008,1,1), Time.utc(2008,12,31,23,59,59)).and_return(@post)
      get :on, :year => "2008", :blog_id => "1"
      response.should be_success
      assigns[:date_range][:descriptor].should eql(' in 2008')
    end

    it "should be successful on year, month search" do
      @post.should_receive(:paginate).with({ :include => [:comments, :user, :tags], 
                                             :per_page => 10, :page => nil }).and_return([@post])
      @post.should_receive(:in_range).with(Time.utc(2008,7,1), Time.utc(2008,7,31,23,59,59)).and_return(@post)
      get :on, :year => "2008", :month => '7', :blog_id => "1"
      response.should be_success
      assigns[:date_range][:descriptor].should eql(' in July 2008')
    end

    it "should be successful on year, month and day search" do
      @post.should_receive(:paginate).with({ :include => [:comments, :user, :tags], 
                                             :per_page => 10, :page => nil }).and_return([@post])
      @post.should_receive(:in_range).with(Time.utc(2008,7,23), Time.utc(2008,7,23,23,59,59)).and_return(@post)
      get :on, :year => "2008", :month => '7', :day => '23', :blog_id => "1"
      response.should be_success
      assigns[:date_range][:descriptor].should eql(' on Wednesday July 23, 2008')
    end

    it "should show no posts found and redirect (with message) when none in date range" do
      @post.should_receive(:in_range).with(Time.utc(2007,1,1), Time.utc(2007,12,31,23,59,59)).and_return([])
      get :on, :year => "2007", :blog_id => "1"
      flash[:notice].should_not be_empty
      response.should redirect_to(blog_posts_url(@blog))
    end

  end   
  
  
  describe "handling GET blogs/1/tag_name" do

    def do_get
      get :tagged, :blog_id => "1", :tag => 'SoMe_taG'
    end

    it "should be successful, render index template and assign posts for the view" do
      Tag.should_receive(:find_by_name).with('some tag').and_return(@tag)
      @blog.should_receive(:posts).and_return(@post)
      @post.should_receive(:published).and_return(@post)
      @post.should_receive(:with_tag).with(@tag).and_return(@post)
      @post.should_receive(:empty?).and_return(false)
      @post.should_receive(:paginate).with({ :include => [:comments, :user, :tags],
                                             :per_page => 10, :page => nil }).and_return([@post])
      do_get
      response.should be_success
      response.should render_template('index')
      assigns[:blog].should == @blog
      assigns[:tag].should equal(@tag)
      assigns[:posts].should == [@post]
    end
    
    
    it "should be redirect to blog posts url when no posts found" do
      Tag.should_receive(:find_by_name).with('some tag').and_return(@tag)
      @blog.should_receive(:posts).and_return(@post)
      @post.should_receive(:published).and_return(@post)
      @post.should_receive(:with_tag).with(@tag).and_return([])
      do_get
      flash[:notice].should_not be_empty
      response.should redirect_to(blog_posts_url(@blog))
    end

  end


  describe "handling GET /blogs/1/tag_name.atom" do

    def do_get
      @request.env["HTTP_ACCEPT"] = "application/atom+xml"
      get :tagged, :blog_id => "1", :tag => 'some_tag'  
    end

    it "should be successful, render recent limited posts as XML" do
      Tag.should_receive(:find_by_name).with('some tag').and_return(@tag)
      @blog.should_receive(:posts).and_return(@post)
      @post.should_receive(:published).and_return(@post)
      @post.should_receive(:with_tag).with(@tag).and_return(@post)
      @post.should_receive(:empty?).and_return(false)
      @post.should_receive(:recent).and_return([@post])
      do_get
      response.should be_success
      response.should render_template('index')
      assigns[:blog].should == @blog
      assigns[:tag].should equal(@tag)
      assigns[:posts].should == [@post]
    end
    
  end

  
  describe "handling GET /blogs/1/:year/:month/:permalink" do

    before(:each) do
      date_range = { :start => Time.utc("2008", "7", "1").to_date, 
                     :end => Time.utc("2008", "7", "31").to_date }
      Post.should_receive(:get_date_range).with('2008', '7', nil).and_return(date_range)
      @blog.should_receive(:posts).and_return(@post)
      @post.should_receive(:published).and_return(@post)
      @post.should_receive(:in_range).with(date_range[:start], date_range[:end]).and_return(@post)
    end

    def do_get
      get :permalink, :blog_id => "1", 
          :year => "2008", :month => "7", :permalink => 'some-post-title'
    end

    it "should be successful, render show template and asssign the post for the view" do
      @post.should_receive(:find_by_permalink).with('some-post-title',
                                                    { :include => [:comments, :user, :tags] }).and_return(@post)
      Comment.should_receive(:new).and_return(mock_model(Comment))
      do_get
      response.should be_success
      response.should render_template('permalink')
      assigns[:blog].should == @blog
      assigns[:post].should equal(@post)
    end
    
    it "should render 404 for RecordNotFound on GET /blogs/1/:year/:month/not-a-found-permalink" do
      controller.use_rails_error_handling!
      @post.should_receive(:find_by_permalink).with('not-a-found-permalink',
                                                    { :include => [:comments, :user, :tags] }).and_raise(ActiveRecord::RecordNotFound)
      get :permalink, :blog_id => "1", 
          :year => "2008", :month => "7", :permalink => 'not-a-found-permalink'
      response.should render_template("#{RAILS_ROOT}/public/404.html")
    end

  end

end