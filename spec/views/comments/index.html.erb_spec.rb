require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/comments/index" do
  
  include ApplicationHelper
  include CommentsHelper
  
  
  before(:each) do    
    @blog_1 = mock_model(Blog, :title => 'Blog Title 1')               
    @post_1 = mock_model(Post, :title => 'Post Title 1')
    @user_1 = mock_model(User, :name => 'User Name 1')
    @comment_1 = mock_model(Comment, :name => 'somebody random', :created_at => Time.now, :email => 'hh@kk.com', :website => '', :body => '')
    @comment_1.should_receive(:post).at_least(1).times.and_return(@post_1)
    @post_1.should_receive(:blog).at_least(1).times.and_return(@blog_1)
    
    @comment_1.should_receive(:user).and_return(nil)
    
    assigns[:comments] = [@comment_1]
    assigns[:comments].stub!(:total_pages).and_return(0)
  end
  
  it "should render list of comments" do
    render 'comments/index' 
    response.should have_tag("h1",  :text => "Blog Title 1 comments") 
  end
  
  it "should render list of comments on post" do
    assigns[:post] = @post_1
    render 'comments/index' 
    response.should have_tag("h1",  :text => "Blog Title 1 comments on Post Title 1") 
  end
  
  it "should render list of comments by user" do
    assigns[:user] = @user_1
    render 'comments/index' 
    response.should have_tag("h1",  :text => "Blog Title 1 comments by User Name 1") 
  end
  
end