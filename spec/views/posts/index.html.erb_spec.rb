require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/posts/index" do  
                    
  include ApplicationHelper
  include PostsHelper
 
  before(:each) do
    
    blog = mock_model(Blog, :title => 'Blog Title')
    @user = mock_model(User, :name => 'Jett Loe')
    @tag = mock_model(Tag, :name => 'tag name') 
    # with summary
    post_98 = mock_model(Post)
    post_98.should_receive(:title).and_return("MyStringTitle1")
    post_98.should_receive(:permalink).at_least(1).times.and_return("my-string-title-1")
    post_98.should_receive(:publish_date).at_least(1).times.and_return(Time.now)
    post_98.should_receive(:user).twice.and_return(mock_model(User, :name => 'matt'))   
    post_98.should_receive(:comments).and_return([])
    post_98.should_receive(:tags).at_least(1).times.and_return([@tag])  
    post_98.should_receive(:blog).twice.and_return(blog)          
    post_98.should_receive(:summary).twice.and_return('Not Blank')       
    post_98.should_not_receive(:body_formatted)
                  
    # no summary, some comments
    post_99 = mock_model(Post)
    post_99.should_receive(:title).and_return("MyStringTitle2")       
    post_99.should_receive(:permalink).at_least(1).times.and_return("my-string-title-2")
    post_99.should_receive(:body_formatted).and_return("MyStringBody")     
    post_99.should_receive(:publish_date).at_least(1).times.and_return(Time.now)
    post_99.should_receive(:user).twice.and_return(mock_model(User, :name => 'jett')) 
    post_99.should_receive(:comments).twice.and_return([mock_model(Comment), mock_model(Comment)])
    post_99.should_receive(:tags).at_least(1).times.and_return([@tag])
    post_99.should_receive(:blog).twice.and_return(blog)
    post_99.should_receive(:summary).and_return('')
              
    assigns[:blog] = blog
    assigns[:posts] = [post_98, post_99]
    assigns[:posts].stub!(:total_pages).and_return(0)          
  end

  it "should render list of posts" do
    render "/posts/index.html.erb"      
    response.should have_tag("h1",  :text => "Blog Title posts") 
    response.should have_tag("h2>a", "MyStringTitle1", 1)
    response.should have_tag("p", "Not Blank", 1)    
    response.should have_tag("p>a", "no comments yet, post one now", 1)
    
    response.should have_tag("h2>a", "MyStringTitle2", 1)         
    response.should have_tag("p>a", "2 comments", 1)
  end    
  
  it "should show title for users blog posts" do
    assigns[:user] = @user
    render "/posts/index.html.erb"                               
    response.should have_tag("h1",  :text => "Blog Title posts by Jett Loe")
  end

  it "should show title for blog posts tagged with" do
    assigns[:tag] = @tag
    render "/posts/index.html.erb"                               
    response.should have_tag("h1",  :text => "Blog Title posts tagged with tag name")
  end
  
  it "should show title for users blog posts tagged with" do
    assigns[:user] = @user
    assigns[:tag] = @tag
    render "/posts/index.html.erb"                               
    response.should have_tag("h1",  :text => "Blog Title posts tagged with tag name by Jett Loe")
  end
  
  
  describe "hAtom feed" do
  
    it "should have the basic attributes on posts for hEntry, hCard and rel-tag" do
      render "/posts/index.html.erb"
      # post
      response.should have_tag('div[class=?]>h2[class=?]>a[rel=?]', "hentry", "entry-title", "bookmark")
      response.should have_tag('abbr[class=?]', "updated")
      response.should have_tag('div[class=?]', "entry-summary")  
      # author
      response.should have_tag('span[class=?]>a[class=?]', "vcard author", "url fn")
      # tag  
      response.should have_tag('a[rel=?]', "tag")
    end
    
  end
  
end   