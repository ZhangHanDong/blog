require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/posts/index" do  
                    
  include ApplicationHelper
  include PostsHelper
 
  before(:each) do                
    # with summary
    post_98 = mock_model(Post)
    post_98.should_receive(:title).and_return("MyStringTitle1")
    post_98.should_receive(:publish_date).and_return(Time.now)
    post_98.should_receive(:user).twice.and_return(mock_model(User, :name => 'matt'))   
    post_98.should_receive(:comments).and_return([])
    post_98.should_receive(:tags).and_return([])      
    post_98.should_receive(:summary).twice.and_return('Not Blank')       
    post_98.should_not_receive(:body_formatted)
                  
    # no summary, some comments
    post_99 = mock_model(Post)
    post_99.should_receive(:title).and_return("MyStringTitle2")
    post_99.should_receive(:body_formatted).and_return("MyStringBody")     
    post_99.should_receive(:publish_date).and_return(Time.now)
    post_99.should_receive(:user).twice.and_return(mock_model(User, :name => 'jett')) 
    post_99.should_receive(:comments).twice.and_return([mock_model(Comment), mock_model(Comment)])
    post_99.should_receive(:tags).and_return([])
    post_99.should_receive(:summary).and_return('')
     
    assigns[:posts] = [post_98, post_99]
    assigns[:posts].stub!(:total_pages).and_return(0)          
  end

  it "should render list of posts" do
    render "/posts/index.html.erb" 
    response.should have_tag("h2>a", "MyStringTitle1", 1)
    response.should have_tag("p", "Not Blank", 1)    
    response.should have_tag("p>a", "no comments yet, post one now", 1)
    
    response.should have_tag("h2>a", "MyStringTitle2", 1)         
    response.should have_tag("p>a", "2 comments", 1)
  end
end   