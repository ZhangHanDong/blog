require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/comments/new" do
  
  include ApplicationHelper
  include CommentsHelper   
  
  fixtures :users   
  
  before(:each) do
    # comment form          
    @blog = mock_model(Blog, :title => 'Blog Title')
    @post = mock_model(Post)       
    @post.should_receive(:blog).and_return(@blog)  
    @post.stub!(:title).and_return('Post Title') 
    @post.stub!(:permalink_url).and_return({})
       
    @comment = Comment.new
    @comment.stub!(:new_record?).and_return(true)
    
    assigns[:comment] = @comment
    assigns[:blog] = @blog
    assigns[:post] = @post
  end
 
 
  it "should show current logged in users name and email auto filled on create/new" do
    login_as :quentin
    stub!(:reset_session)
    
    render "/comments/new"
    
    response.should have_tag("form[action=?][method=post]", blog_post_comments_path(@blog, @post))
    response.should have_tag("input#comment_name[value=?]", 'Quentin Bart')
    response.should have_tag("input#comment_email[value=?]", 'quentin@example.com')
    response.should have_tag("input#comment_spam_question_id")
    response.should have_tag("input#comment_spam_answer")
  end
end
