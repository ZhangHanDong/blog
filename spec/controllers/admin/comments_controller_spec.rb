require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Admin::CommentsController do

  fixtures :users

  describe "handling GET /admin/posts/1/comments" do

    before(:each) do
      login_as :quentin
      stub!(:reset_session)
      @post = mock_model(Post)
      @comment = mock_model(Comment)
      Post.stub!(:find).and_return(@post)
      @post.should_receive(:comments).at_least(3).times.and_return(@comment)
      @post.comments.should_receive(:paginate).with(:all, {:order => "created_at DESC", :page => nil, :per_page => 10}).and_return([@comment])
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

    it "should assign the found comments for the view" do
      do_get
      assigns[:comments].should == [@comment]
    end
  end


  describe "handling GET /admin/posts/1/comments.xml" do

    before(:each) do
      login_as :quentin
      stub!(:reset_session)
      @post = mock_model(Post)
      @comment = mock_model(Comment, :to_xml => "XML")
      @comments = [@comment]
      Post.stub!(:find).and_return(@post)
      @post.stub!(:comments).and_return([@comment])
      @post.should_receive(:comments).and_return(@comments)
    end

    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :index
    end

    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should render the found comments as xml" do
      @comments.should_receive(:to_xml).and_return("XML")
      do_get
    end
  end

  describe "handling unsuccessful GET for /admin/posts/1/comment/15155199" do
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

  describe "handling GET /admin/posts/1/comment/1" do

    before(:each) do
      login_as :quentin
      stub!(:reset_session)
      @comment = mock_model(Comment)
      Post.stub!(:find).and_return(mock_model(Post))
      Comment.stub!(:find).and_return(@comment)
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

    it "should find the comment requested" do
      Comment.should_receive(:find).with("1").and_return(@comment)
      do_get
    end

    it "should assign the found comment for the view" do
      do_get
      assigns[:comment].should equal(@comment)
    end
  end

  describe "handling GET /admin/posts/1/comment/1.xml" do

    before(:each) do
      login_as :quentin
      stub!(:reset_session)
      @comment = mock_model(Comment, :to_xml => "XML")
      Post.stub!(:find).and_return(mock_model(Post))
      Comment.stub!(:find).and_return(@comment)
    end

    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :show, :id => "1"
    end

    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should find the comment requested" do
      Comment.should_receive(:find).with("1").and_return(@comment)
      do_get
    end

    it "should render the found comment as xml" do
      @comment.should_receive(:to_xml).and_return("XML")
      do_get
      response.body.should == "XML"
    end
  end

  describe "handling GET /admin/posts/1/comments/new" do

    before(:each) do
      login_as :quentin
      stub!(:reset_session)
      Post.stub!(:find).and_return(mock_model(Post))
      @comment = mock_model(Comment)
      Comment.stub!(:new).and_return(@comment)
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

    it "should create an new comment" do
      Comment.should_receive(:new).and_return(@comment)
      do_get
    end

    it "should not save the new comment" do
      @comment.should_not_receive(:save)
      do_get
    end

    it "should assign the new comment for the view" do
      do_get
      assigns[:comment].should equal(@comment)
    end
  end



  describe "handling GET /admin/posts/1/comments/1/edit" do

    before(:each) do
      login_as :quentin
      stub!(:reset_session)
      @comment = mock_model(Comment)
      Post.stub!(:find).and_return(mock_model(Post))
      Comment.stub!(:find).and_return(@comment)
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

    it "should find the comment requested" do
      Comment.should_receive(:find).and_return(@comment)
      do_get
    end

    it "should assign the found Comment for the view" do
      do_get
      assigns[:comment].should equal(@comment)
    end
  end

  describe "handling POST /admin/posts/1/comments" do

    before(:each) do
      login_as :quentin
      stub!(:reset_session)
      @post = mock_model(Post, :to_param => "1")
      Post.stub!(:find).and_return(@post)
      @comment = mock_model(Comment, :to_param => "2")
      Comment.stub!(:new).and_return(@comment)
    end

    describe "with setting author (user) and into comments collection (sucessful save)" do

      def do_post
        @post.should_receive(:comments).and_return([])
        @comment.should_receive(:user=).with(users(:aaron)).and_return(true)
        @post.should_receive(:save).and_return(true)
        post :create, :comment => {}
      end

      it "should create a new comment with the correct author set" do
        Comment.should_receive(:new).with({}).and_return(@comment)
        login_as :aaron
        do_post
      end

      it "should redirect to the new comment" do
        login_as :aaron
        do_post
        response.should redirect_to(admin_post_comment_url("1", "2"))
      end

    end


    describe "with failed save" do

      def do_post
        @post.should_receive(:comments).and_return([])
        @comment.should_receive(:user=).with(users(:aaron)).and_return(true)
        @post.should_receive(:save).and_return(false)
        post :create, :comment => {}
      end

      it "should re-render 'new'" do
        login_as :aaron
        do_post
        response.should render_template('new')
      end

    end
  end

  describe "handling PUT /admin/posts/1/comments/1" do

    before(:each) do
      login_as :quentin
      stub!(:reset_session)
      @post = mock_model(Post, :to_param => "1")
      Post.stub!(:find).and_return(@post)
      @comment = mock_model(Comment, :to_param => "1")
      @post.stub!(:comments).and_return(@comment)
      @comment.stub!(:find).and_return(@comment)
    end

    describe "with successful update" do

      def do_put
        @comment.should_receive(:update_attributes).and_return(true)
        put :update, :id => "1", :post_id => "1", :comment => {}
      end

      it "should update the found comment" do
        do_put
        assigns[:comment].should equal(@comment)
      end

      it "should assign the found comment for the view" do
        do_put
        assigns[:comment].should equal(@comment)
      end

      it "should redirect to the comment" do
        do_put
        response.should redirect_to(admin_post_comment_url("1", "1"))
      end

    end

    describe "with failed update" do

      def do_put
        @comment.should_receive(:update_attributes).and_return(false)
        put :update, :id => "1"
      end

      it "should re-render 'edit'" do
        do_put
        response.should render_template('edit')
      end

    end
  end
  

  describe "handling DELETE /admin/posts/1/comments/1" do

    before(:each) do
      login_as :quentin
      stub!(:reset_session)
      @post = mock_model(Post, :to_param => "1")
      Post.stub!(:find).and_return(@post)
      @comment = mock_model(Comment, :destroy => true)
      @post.stub!(:comments).and_return(@comment)
      @comment.stub!(:find).and_return(@comment)
    end

    def do_delete
      delete :destroy, :id => "1"
    end

    it "should call destroy on the found comment" do
      @comment.should_receive(:destroy)
      do_delete
    end

    it "should redirect to the comments list" do
      do_delete
      response.should redirect_to(admin_post_comments_url("1"))
    end
  end
end
