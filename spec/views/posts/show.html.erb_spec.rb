require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/posts/show" do  
  
  include ApplicationHelper
  include PostsHelper     
  
  fixtures :users  
  
  before(:each) do
    @blog = mock_model(Blog, :title => 'Blog Title')
    @post = mock_model(Post, :to_param => 1)
    @comment = mock_model(Comment)   
    @tag = mock_model(Tag, :name => 'Tag Name')
     
    @post.should_receive(:title).and_return("MyStringTitle1") 
    @post.should_receive(:permalink).at_least(1).times.and_return("my-string-title-1") 
    @post.should_receive(:publish_date).at_least(1).times.and_return(Time.now)
    @post.should_receive(:user).twice.and_return(mock_model(User, :name => 'matt'))   
    @post.should_receive(:comments).twice.and_return([])
    @post.should_receive(:tags).at_least(1).times.and_return([@tag])      
    @post.should_receive(:blog).and_return(@blog)      
    @post.should_receive(:summary).at_least(1).and_return('Not Blank')       
    @post.should_receive(:body_formatted).and_return('Body Text')        
                                 
    @comment.stub!(:new_record?).and_return(true)
    @comment.should_receive(:website).and_return("")
    @comment.should_receive(:body).and_return("")
    @comment.should_receive(:name).at_least(1).times.and_return(nil)
    @comment.should_receive(:email).at_least(1).times.and_return(nil)
                          
    assigns[:blog] = @blog
    assigns[:post] = @post
    assigns[:comment] = @comment
  end


  it "should render an individual post with recent comments" do
    render "/posts/show"
    response.should have_text(/MyStringTitle1/)
    response.should have_text(/matt/)
    response.should have_text(/Not Blank/)
    response.should have_text(/Body Text/) 
  end
  
  
  it "should show current logged in users name and email auto filled on create/new" do
    login_as :quentin
    stub!(:reset_session)
    render "/posts/show"                  
    
    response.should have_tag("form[action=?][method=post]", blog_post_comments_path(@blog, @post)) do  
      with_tag('input#comment_name[value=?]', 'Quentin Bart')
      with_tag('input#comment_email[value=?]', 'quentin@example.com')
      with_tag('input#comment_spam_question_id')
      with_tag('input#comment_spam_answer')
    end
  end  
  
  
  describe "hAtom feed" do
  
    it "should have the basic attributes on the post for hEntry, hCard and rel-tag" do
      render "/posts/show"
      # post
      response.should have_tag('div[class=?]>h1[class=?]>a[rel=?]', "hentry", "entry-title", "bookmark")
      response.should have_tag('abbr[class=?]', "updated")
      response.should have_tag('div[class=?]', "entry-content")  
      # author
      response.should have_tag('span[class=?]>a[class=?]', "vcard author", "url fn")
      # tag  
      response.should have_tag('a[rel=?]', "tag")
    end
    
  end
  
end
            

