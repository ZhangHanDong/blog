require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "/admin/posts/index.html.erb" do
  include Admin::PostsHelper
  
  before(:each) do           
    blog = mock_model(Blog, :title => 'Blog Title') 
    @user = mock_model(User, :name => 'Cowboy Joe')
    @tag = mock_model(Tag, :name => 'fitchy')  
    post_98 = mock_model(Post)               
    post_98.stub!(:blog).and_return(blog)  
    post_98.should_receive(:title).and_return("MyString")
    post_98.should_receive(:publish_date).and_return(Time.now)
    post_98.should_receive(:in_draft).and_return(false)
    post_98.should_receive(:user).and_return(false)   
    post_98.should_receive(:comments).twice.and_return([])
    post_99 = mock_model(Post)             
    post_99.stub!(:blog).and_return(blog)  
    post_99.should_receive(:title).and_return("MyString")
    post_99.should_receive(:publish_date).and_return(Time.now)
    post_99.should_receive(:in_draft).and_return(false)
    post_99.should_receive(:user).and_return(false) 
    post_99.should_receive(:comments).twice.and_return([])      
    
    assigns[:blog] = blog      
    assigns[:posts] = [post_98, post_99]
    assigns[:posts].stub!(:total_pages).and_return(0)
  end

  it "should render list of posts for a blog" do
    render "/admin/posts/index.html.erb"            
    response.should have_tag("h1",  :text => "Blog Title posts")      
    response.should have_tag("tr>td", "MyString", 2)
    response.should have_tag("tr>td", "MyString", 2)
  end
  
  it "should show title for a list of user posts in a blog" do
    assigns[:user] = @user      
    render "/admin/posts/index.html.erb"            
    response.should have_tag("h1",  :text => "Blog Title posts by Cowboy Joe")      
  end
    
  it "should show title for a list of posts in a blog tagged with a tag" do
    assigns[:tag] = @tag      
    render "/admin/posts/index.html.erb"            
    response.should have_tag("h1",  :text => "Blog Title posts tagged with fitchy")      
  end
  
end

