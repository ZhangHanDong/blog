require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "/admin/comments/edit.html.erb" do
  include Admin::CommentsHelper
  
  before do             
    @blog = mock_model(Blog, :title => 'Blog Title') 
    @post = mock_model(Post)                    
    @post.stub!(:blog).and_return(@blog)
    @post.stub!(:title).and_return('Post Title')
    @comment = mock_model(Comment)             
    @comment.stub!(:post).and_return(@post)
    @comment.stub!(:name).and_return("MyString")
    @comment.stub!(:email).and_return("MyString")
    @comment.stub!(:website).and_return(Time.now)
    @comment.stub!(:body).and_return("MyText")
    assigns[:post] = @post
    assigns[:comment] = @comment
  end

  it "should render edit comment form" do
    render "/admin/comments/edit.html.erb"
    
    response.should have_tag("form[action=#{admin_blog_post_comment_path(@blog, @post, @comment)}][method=post]")
    response.should have_tag('input#comment_name[name=?]', "comment[name]")
    response.should have_tag('input#comment_email[name=?]', "comment[email]")
    response.should have_tag('input#comment_website[name=?]', "comment[website]") 
    response.should have_tag('textarea#comment_body[name=?]', "comment[body]")
  end
end


