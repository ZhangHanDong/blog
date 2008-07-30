require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/comments/new" do
  
  include ApplicationHelper
  include CommentsHelper   
  
  fixtures :users   
  
  before(:each) do
    # comment form
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
 
  it "should show current logged in users name and email auto filled on create/new" do
    login_as :quentin
    stub!(:reset_session)
    @comment.stub!(:name).and_return(nil)
    @comment.stub!(:email).and_return(nil)
    
    render "/comments/new"
    
    response.should have_tag("form[action=?][method=post]", post_comments_path(@post)) do  
      with_tag('input#comment_name[value=?]', 'Quentin Bart')
      with_tag('input#comment_email[value=?]', 'quentin@example.com')
    end
  end
end
