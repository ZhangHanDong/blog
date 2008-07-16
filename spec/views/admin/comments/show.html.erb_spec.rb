require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "/admin/comments/show.html.erb" do
  include Admin::CommentsHelper
  
  before(:each) do
    @post = mock_model(Post)
    @post.stub!(:title).and_return('Post Title')
    @comment = mock_model(Comment)  
    @comment.stub!(:name).and_return("MyString")
    @comment.stub!(:email).and_return("MyString")
    @comment.stub!(:website).and_return("MyString")
    @comment.stub!(:body).and_return("MyText")      
    @comment.stub!(:created_at).and_return(Time.now)      
    
    assigns[:post] = @post
    assigns[:comment] = @comment
  end

  it "should render an individual comment" do
    render "/admin/comments/show.html.erb"
    response.should have_text(/MyString/)
    response.should have_text(/MyString/)
    response.should have_text(/MyText/)
  end
end

