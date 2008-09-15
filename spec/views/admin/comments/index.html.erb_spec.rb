require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "/admin/comments/index.html.erb" do
  include Admin::CommentsHelper
  
  before(:each) do          
    @blog = mock_model(Blog, :title => 'Blog Title')  
    @user = mock_model(User, :name => 'Cowboy Joe')
    @post = mock_model(Post)                    
    @post.stub!(:blog).and_return(@blog)
    @post.stub!(:title).and_return('Post Title')
    @comment_98 = mock_model(Comment)  
    @comment_98.stub!(:name).and_return("MyString")
    @comment_98.stub!(:email).and_return("MyString")
    @comment_98.stub!(:website).and_return("MyString")
    @comment_98.stub!(:user).and_return(nil)
    @comment_98.stub!(:body).and_return("MyText")  
    @comment_98.stub!(:post).and_return(@post)  
    
    @comment_99 = mock_model(Comment)  
    @comment_99.stub!(:name).and_return("MyString")
    @comment_99.stub!(:email).and_return("MyString")
    @comment_99.stub!(:website).and_return("MyString")
    @comment_99.stub!(:user).and_return(nil) 
    @comment_99.stub!(:body).and_return("MyText")
    @comment_99.stub!(:post).and_return(@post)  
    
    assigns[:blog] = @blog  
    assigns[:post] = @post 
    assigns[:comments] = [@comment_98, @comment_99] 
    assigns[:comments].stub!(:total_pages).and_return(0)           
  end

  it "should render list of comments" do
    render "/admin/comments/index.html.erb"        
    response.should have_tag("h1",  :text => "Blog Title comments on Post Title")       
    response.should have_tag("tr>td", "MyString", 2)
    response.should have_tag("tr>td", "MyString", 2)
  end 
  
  it "should show title for list of users comments" do
    assigns[:post] = nil
    assigns[:user] = @user
    render "/admin/comments/index.html.erb"        
    response.should have_tag("h1",  :text => "Blog Title comments by Cowboy Joe")       
  end 
  
  it "should show title for all blog comments" do
    assigns[:post] = nil
    render "/admin/comments/index.html.erb"        
    response.should have_tag("h1",  :text => "Blog Title comments")       
  end
end

