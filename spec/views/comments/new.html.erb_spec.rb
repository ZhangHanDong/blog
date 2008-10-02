require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/comments/new" do
  
  include ApplicationHelper
  include CommentsHelper   
  
  fixtures :users   
  
  before(:each) do
    # comment form          
    @blog = mock_model(Blog, :title => 'Blog Title')
    @post = mock_model(Post)       
    @post.should_receive(:blog).twice.and_return(@blog)  
    @post.stub!(:title).and_return('Post Title') 
    @post.should_receive(:permalink).at_least(1).times.and_return("post-title")    
    @post.should_receive(:publish_date).at_least(1).times.and_return(Time.now)  
    @comment = mock_model(Comment)     
    @comment.stub!(:new_record?).and_return(true)  
    @comment.stub!(:name).and_return("MyString")
    @comment.stub!(:email).and_return("MyString")
    @comment.stub!(:website).and_return(Time.now)
    @comment.stub!(:body).and_return("MyText")
    assigns[:blog] = @blog
    assigns[:post] = @post
    assigns[:comment] = @comment
  end
 
  it "should show current logged in users name and email auto filled on create/new" do
    login_as :quentin
    stub!(:reset_session)
    @comment.stub!(:name).and_return(nil)
    @comment.stub!(:email).and_return(nil)
    
    render "/comments/new"
    
    response.should have_tag("form[action=?][method=post]", blog_post_comments_path(@blog, @post)) do  
      with_tag('input#comment_name[value=?]', 'Quentin Bart')
      with_tag('input#comment_email[value=?]', 'quentin@example.com')
      with_tag('input#comment_spam_question_id')
      with_tag('input#comment_spam_answer')
    end
  end
end
