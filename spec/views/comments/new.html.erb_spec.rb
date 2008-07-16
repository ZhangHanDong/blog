require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/comments/new" do
  
  include ApplicationHelper
  include CommentsHelper
  
  before(:each) do
    @post = mock_model(Post, :to_param => 1)
    @comment = mock_model(Comment, :to_param => 1)   
     
    @post.should_receive(:title).and_return("MyStringTitle1")
                                 
    # comment form
    @comment.should_receive(:name).and_return("")
    @comment.should_receive(:email).and_return("")
    @comment.should_receive(:website).and_return("")
    @comment.should_receive(:body).and_return("")

    assigns[:post] = @post
    assigns[:comment] = @comment
  end

  it "should render the form for adding a new comment to the post" do
    render 'comments/new'   
    response.should have_text(/MyStringTitle1/)
  end
end
