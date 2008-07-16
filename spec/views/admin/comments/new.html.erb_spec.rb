require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "/admin/comments/new.html.erb" do
  include Admin::CommentsHelper

  before do
    @post = mock_model(Post)
    @post.stub!(:title).and_return('Post Title')
    @comment = mock_model(Comment)
    @comment.stub!(:new_record?).and_return(true)  
    @comment.stub!(:name).and_return("MyString")
    @comment.stub!(:email).and_return("MyString")
    @comment.stub!(:website).and_return(Time.now)
    @comment.stub!(:body).and_return("MyText")
    assigns[:post] = @post
    assigns[:comment] = @comment
  end

  it "should render the new comment form" do
    render "/admin/comments/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", admin_post_comments_path(@post)) do  
      with_tag('input#comment_name[name=?]', "comment[name]")
      with_tag('input#comment_email[name=?]', "comment[email]")
      with_tag('input#comment_website[name=?]', "comment[website]") 
      with_tag('textarea#comment_body[name=?]', "comment[body]")
    end
  end
end


