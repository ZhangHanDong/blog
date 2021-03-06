require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Admin::CommentsController do

  fixtures :users

  before(:each) do
    login_as :quentin
    stub!(:reset_session)
                                     
    @blog = mock_model(Blog)
    @post = mock_model(Post)
    @user = mock_model(User)            
    @comment = mock_model(Comment, :destroy => true)
    @comments  = mock("Array of Comments", :to_xml => "XML")
    
    Blog.stub!(:find).and_return(@blog)
    Post.stub!(:find).and_return(@post)  
    
    Comment.stub!(:find).and_return(@comment)
    Comment.stub!(:new).and_return(@comment)
  end
                
  
  describe "handling GET /admin/blogs/1/comments" do

    def do_get
      get :index, :blog_id => "1"     
    end

    it "should be successful, render template and assign comments for view" do
      @blog.should_receive(:comments).and_return(@comments)
      @comments.should_receive(:paginate).with({ :include => { :post => :blog }, 
                                                 :per_page => 10, :page => nil }).and_return([@comment])
      do_get
      response.should be_success
      response.should render_template('index')
      assigns[:blog].should == @blog    
      assigns[:comments].should == [@comment] 
    end
  end
  
  
  describe "handling GET /admin/blogs/1/comments.xml" do

    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :index, :blog_id => "1"     
    end

    it "should be successful and render comments as xml" do
      @blog.should_receive(:comments).and_return(@comments) 
      @comments.should_receive(:recent).and_return(@comments)
      @comments.should_receive(:to_xml).and_return("XML")
      do_get
      response.should be_success
    end
  end
  
  
  describe "handling GET /admin/users/1/comments" do
                                       
    before(:each) do
      User.stub!(:find).and_return(@user)
    end

    def do_get
      get :index, :user_id => "1" 
    end

    it "should be successful, render template and assign comments and user for view" do
      @user.should_receive(:comments).and_return(@comments)
      @comments.should_receive(:paginate).with({ :include => { :post => :blog }, 
                                                 :per_page => 10, :page => nil }).and_return([@comment])
      do_get
      response.should be_success
      response.should render_template('index')     
      assigns[:user].should == @user
      assigns[:comments].should == [@comment] 
    end
  end
  

  describe "handling GET /admin/blogs/1/posts/1/comments" do
                                               
    def do_get
      get :index, :blog_id => "1", :post_id => "1"
    end
    
    it "should be successful, render template and assign comments for view" do
      @blog.should_receive(:posts).and_return(@post)
      @post.should_receive(:find).and_return(@post)  
      @post.should_receive(:comments).and_return(@comments) 
      @comments.should_receive(:paginate).with({ :include => { :post => :blog }, 
                                                 :per_page => 10, :page => nil }).and_return([@comment])
      do_get
      response.should be_success
      response.should render_template('index')     
      assigns[:blog].should == @blog
      assigns[:post].should == @post
      assigns[:comments].should == [@comment] 
    end
  end
  
  
  describe "handling GET /admin/blogs/1/users/1/comments" do

    before(:each) do
      User.stub!(:find).and_return(@user)
    end
    
    def do_get
      get :index, :blog_id => "1", :user_id => "1"
    end

    it "should be successful, render template and assign comments for view" do
      @blog.should_receive(:comments).and_return(@comments)
      @comments.should_receive(:by_user).with(@user).and_return(@comments) 
      @comments.should_receive(:paginate).with({ :include => { :post => :blog }, 
                                                 :per_page => 10, :page => nil }).and_return([@comment])
      do_get
      response.should be_success
      response.should render_template('index')   
      assigns[:blog].should == @blog
      assigns[:user].should == @user    
      assigns[:comments].should == [@comment] 
    end
  end
  

  describe "handling GET /admin/blogs/1/posts/1/comment/1" do

    def do_get
      get :show, :id => "1", :blog_id => "1", :post_id => "1"
    end

    it "should be successful, render show template find the comment and assign for the view" do
      Comment.should_receive(:find).with("1", { :include => [:post, :user] }).and_return(@comment)
      do_get
      response.should be_success
      response.should render_template('show')                                                 
      assigns[:comment].should equal(@comment)      
    end
                                              
  end  
  

  describe "handling GET /admin/blogs/1/posts/1/comment/1.xml" do

    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :show, :id => "1", :blog_id => "1", :post_id => "1"
    end

    it "should be successful, render as XML and find the comment and assign for the view" do   
      Comment.should_receive(:find).with("1", { :include => [:post, :user] }).and_return(@comment)   
      @comment.should_receive(:to_xml).and_return("XML")  
      do_get
      response.should be_success       
      response.body.should == "XML" 
    end
  end 
    

  describe "handling GET /admin/blogs/1/posts/1/comments/new" do

    def do_get
      get :new, :blog_id => "1", :post_id => "1"
    end

    it "should be successful, render new template, create new comment and assign for view" do
      Comment.should_receive(:new).and_return(@comment)
      @comment.should_not_receive(:save)
      do_get
      response.should be_success
      response.should render_template('new')
      assigns[:comment].should equal(@comment)
    end

  end


  describe "handling GET /admin/blogs/1/posts/1/comments/1/edit" do

    def do_get
      get :edit, :id => "1", :blog_id => "1", :post_id => "1"
    end

    it "should be successful, render edit template, find commment and assign for view" do
      Comment.should_receive(:find).and_return(@comment)
      do_get
      response.should be_success
      response.should render_template('edit')
      assigns[:comment].should equal(@comment)
    end
    
  end
       

  describe "handling POST /admin/blogs/1/posts/1/comments" do

    describe "with setting author (user) and into comments collection (sucessful create)" do

      def do_post                                
        @post.should_receive(:blog).and_return(@blog)
        @post.should_receive(:comments).and_return(@comment)
        @comment.should_receive(:build).and_return(@comment)
        @comment.should_receive(:user=).with(users(:aaron)).and_return(true)
        @post.should_receive(:save).and_return(true)
        post :create, :comment => {}, :blog_id => "1", :post_id => "1"
      end

      it "should create a new comment with the correct author set" do
        login_as :aaron     
        do_post
      end

      it "should redirect to the new comment" do
        login_as :aaron
        do_post
        response.should redirect_to(admin_blog_post_comment_url(@blog, @post, @comment))
      end

    end


    describe "with failed create" do

      def do_post
        @post.should_receive(:comments).and_return(@comment)
        @comment.should_receive(:build).and_return(@comment)
        @comment.should_receive(:user=).with(users(:aaron)).and_return(true)
        @post.should_receive(:save).and_return(false)
        post :create, :comment => {}, :blog_id => "1", :post_id => "1" 
      end

      it "should re-render 'new'" do
        login_as :aaron
        do_post
        response.should render_template('new')
      end

    end
  end


  describe "handling PUT /admin/blogs/1/posts/1/comments/1" do

    describe "with successful update" do

      def do_put 
        @comment.should_receive(:update_attributes).and_return(true)   
        @comment.should_receive(:post).twice.and_return(@post)   
        @post.should_receive(:blog).and_return(@blog)  
        put :update, :id => "1", :post_id => "1", :comment => { }, :blog_id => "1"
      end

      it "should update the found comment and redirect to the comment" do
        do_put
        response.should redirect_to(admin_blog_post_comment_url(@blog, @post, @comment))
      end

    end

    describe "with failed update" do

      def do_put    
        @comment.should_receive(:update_attributes).and_return(false)
        put :update, :id => "1", :blog_id => "1", :post_id => "1"
      end

      it "should re-render 'edit'" do
        do_put
        response.should render_template('edit')
      end

    end
  end
  

  describe "handling DELETE /admin/posts/1/comments/1" do

    def do_delete      
      @comment.should_receive(:post).twice.and_return(@post)   
      @post.should_receive(:blog).and_return(@blog)
      delete :destroy, :id => "1", :blog_id => "1", :post_id => "1"
    end

    it "should call destroy on the found comment and redirect to the comments list" do
      @comment.should_receive(:destroy)                  
      do_delete
      response.should redirect_to(admin_blog_post_comments_url(@blog, @post))
    end
    
  end
  
  
  describe "handling exceptions" do

    before(:each) do
      controller.use_rails_error_handling!
    end

    it "should render 404 for RecordNotFound on GET /admin/blogs/1/posts/1/comments/15155199 " do
      Comment.stub!(:find).and_raise(ActiveRecord::RecordNotFound)
      get :show, :id => "15155199", :blog_id => "1", :post_id => "1"
      response.should render_template("#{RAILS_ROOT}/public/404.html")
    end
    
  end
  
end