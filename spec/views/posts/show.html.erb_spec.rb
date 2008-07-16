require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/posts/show" do  
  
  include ApplicationHelper
  include PostsHelper
  
  before(:each) do
    @post = mock_model(Post, :to_param => 1)
    @comment = mock_model(Comment, :to_param => 1)   
     
    @post.should_receive(:title).and_return("MyStringTitle1")
    @post.should_receive(:publish_date).and_return(Time.now)
    @post.should_receive(:user).and_return(mock_model(User, :name => 'matt'))   
    @post.should_receive(:comments).twice.and_return([])
    @post.should_receive(:tags).and_return([])      
    @post.should_receive(:summary).and_return('Not Blank')       
    @post.should_receive(:body_formatted).and_return('Body Text')        
                                 
    # comment form
    @comment.should_receive(:name).and_return("")
    @comment.should_receive(:email).and_return("")
    @comment.should_receive(:website).and_return("")
    @comment.should_receive(:body).and_return("")

    assigns[:post] = @post
    assigns[:comment] = @comment
  end

  it "should render an individual post with recent comments" do
    render "/posts/show.html.erb"
    response.should have_text(/MyStringTitle1/)
    response.should have_text(/matt/)
    response.should have_text(/Not Blank/)
    response.should have_text(/Body Text/) 
  end  
  
end
