require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')


describe CommentsController do
  
  fixtures :users
  
  before(:each) do
    @post = mock_model(Post, :to_param => "1")
    @comment = mock_model(Comment, :to_param => "2")
    Post.stub!(:find).and_return(@post)
  end

  describe "handling GET /posts/1/comments.atom" do
    
    before(:each) do
      @post.should_receive(:comments).and_return(@comment)
      @comment.should_receive(:recent).and_return(@comment)
    end

    def do_get
      @request.env["HTTP_ACCEPT"] = "application/atom+xml"
      get :index
    end

    it "should be successful" do
      do_get
      response.should be_success
    end

  end


  describe "handling POST /posts/1/comments" do

    before(:each) do
      Comment.should_receive(:new).and_return(@comment)
      @comment.should_receive(:post=).with(@post)
    end

    describe "with setting comment in post collection (sucessful save)" do

      def do_post
        @comment.should_receive(:save).and_return(true)
        post :create, :comment => {}
      end

      it "should redirect to the original post" do
        do_post
        response.should redirect_to(post_url("1"))
      end
      
      it "should set comment user to current_user if logged in" do
        login_as :quentin
        stub!(:reset_session)
        @comment.should_receive(:user=).with(users(:quentin)).and_return(true)
        do_post
      end

    end
    

    describe "with failed save" do

      def do_post
        @comment.should_receive(:save).and_return(false)
        post :create, :comment => {}
      end

      it "should re-render 'new'" do
        do_post
        response.should render_template('new')
      end

    end
  end


  describe "handling unsuccessful GET for /posts/15155199/comments" do
    
    it "should be redirected with flash message" do
      Post.should_receive(:find).and_raise(ActiveRecord::RecordNotFound)
      get :index, :post_id => "15155199"
      response.should redirect_to(root_url)
      flash[:notice].should_not be_empty
    end
    
  end

end
