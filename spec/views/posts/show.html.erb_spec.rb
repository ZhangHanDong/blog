require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/posts/show" do  
  
  include ApplicationHelper
  include PostsHelper     
  
  fixtures :users  
  
  before(:each) do
    @post = mock_model(Post, :to_param => 1)
    @comment = mock_model(Comment)   
     
    @post.should_receive(:title).and_return("MyStringTitle1")
    @post.should_receive(:publish_date).and_return(Time.now)
    @post.should_receive(:user).and_return(mock_model(User, :name => 'matt'))   
    @post.should_receive(:comments).twice.and_return([])
    @post.should_receive(:tags).and_return([])      
    @post.should_receive(:summary).and_return('Not Blank')       
    @post.should_receive(:body_formatted).and_return('Body Text')        
                                 
    @comment.stub!(:new_record?).and_return(true)
    @comment.should_receive(:website).and_return("")
    @comment.should_receive(:body).and_return("")

    assigns[:post] = @post
    assigns[:comment] = @comment
  end

  it "should render an individual post with recent comments" do
    @comment.should_receive(:name).twice.and_return(nil)
    @comment.should_receive(:email).twice.and_return(nil)
    render "/posts/show"
    response.should have_text(/MyStringTitle1/)
    response.should have_text(/matt/)
    response.should have_text(/Not Blank/)
    response.should have_text(/Body Text/) 
  end
  
  
  it "should show current logged in users name and email auto filled on create/new" do
    login_as :quentin
    stub!(:reset_session)
    @comment.should_receive(:name).and_return(nil)
    @comment.should_receive(:email).and_return(nil)
    render "/posts/show"                  
    
    response.should have_tag("form[action=?][method=post]", post_comments_path(@post)) do  
      with_tag('input#comment_name[value=?]', 'Quentin Bart')
      with_tag('input#comment_email[value=?]', 'quentin@example.com')
    end
  end  
  
end
            

