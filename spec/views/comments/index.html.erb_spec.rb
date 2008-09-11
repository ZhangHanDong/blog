require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/comments/index" do
  
  include ApplicationHelper
  include CommentsHelper
  
  
  before(:each) do    
    blog_1 = mock_model(Blog, :title => 'Blog Title 1')               
    post_1 = mock_model(Post, :title => 'Post Title 1')
    user_1 = mock_model(User, :name => 'User Name 1')
    comment_1 = mock_model(Comment, :name => 'somebody random', :created_at => Time.now, :email => 'hh@kk.com', :website => '', :body => '')
    comment_2 = mock_model(Comment, :created_at => Time.now, :email => 'hh@kk.com', :website => '', :body => '') 
    
    comment_1.should_receive(:post).at_least(4).times.and_return(post_1)
    comment_2.should_receive(:post).at_least(3).times.and_return(post_1)
    post_1.should_receive(:blog).at_least(3).times.and_return(blog_1)
    
    comment_1.should_receive(:user).and_return(nil)
    comment_2.should_receive(:user).at_least(3).and_return(user_1)
    
    assigns[:comments] = [comment_1, comment_2]
    assigns[:comments].stub!(:total_pages).and_return(0)
  end
  
  it "should render list of comments" do
    render 'comments/index' 
  end
end