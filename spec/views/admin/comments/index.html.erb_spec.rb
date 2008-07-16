require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "/admin/posts/index.html.erb" do
  include Admin::CommentsHelper
  
  before(:each) do          
    
    @post = mock_model(Post)
    @post.stub!(:title).and_return('Post Title')
    @comment_98 = mock_model(Comment)  
    @comment_98.stub!(:name).and_return("MyString")
    @comment_98.stub!(:email).and_return("MyString")
    @comment_98.stub!(:website).and_return("MyString")
    @comment_98.stub!(:user).and_return(nil)
    @comment_98.stub!(:body).and_return("MyText")  
    
    @comment_99 = mock_model(Comment)  
    @comment_99.stub!(:name).and_return("MyString")
    @comment_99.stub!(:email).and_return("MyString")
    @comment_99.stub!(:website).and_return("MyString")
    @comment_99.stub!(:user).and_return(nil) 
    @comment_99.stub!(:body).and_return("MyText")
    
    assigns[:post] = @post
    assigns[:comments] = [@comment_98, @comment_99] 
    assigns[:comments].stub!(:total_pages).and_return(0)           
  end

  it "should render list of comments" do
    render "/admin/comments/index.html.erb"
    response.should have_tag("tr>td", "MyString", 2)
    response.should have_tag("tr>td", "MyString", 2)
  end
end

