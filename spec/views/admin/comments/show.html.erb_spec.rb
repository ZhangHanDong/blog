require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "/admin/comments/show.html.erb" do
  include Admin::CommentsHelper
  
  before(:each) do          
    @blog = mock_model(Blog)
    @post = mock_model(Post)                    
    @post.stub!(:blog).and_return(@blog)
    @post.stub!(:title).and_return('Post Title')
    @comment = mock_model(Comment)  
    @comment.stub!(:name).and_return("MyString") 
    @comment.stub!(:user).and_return(nil) 
    @comment.stub!(:email).and_return("MyString")
    @comment.stub!(:website).and_return("MyString")
    @comment.stub!(:body).and_return("MyText")      
    @comment.stub!(:created_at).and_return(Time.now)
    @comment.stub!(:post).and_return(@post)      
    
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

