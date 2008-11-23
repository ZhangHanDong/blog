require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "/admin/posts/show.html.erb" do
  include Admin::PostsHelper
  
  before(:each) do
    blog = mock_model(Blog, :title => 'Blog Title')      
    @post = mock_model(Post)
    @user = mock_model(User, :name => 'Jimmeny')
    @post.stub!(:blog).and_return(blog)   
    @post.stub!(:title).and_return("MyString") 
    @post.stub!(:user).and_return(@user) 
    @post.stub!(:permalink_url).and_return({})
    @post.stub!(:publish_date).and_return(Time.now)
    @post.stub!(:summary).and_return("MyText")
    @post.stub!(:body).and_return("MyText")
    @post.stub!(:body_formatted).and_return("MyText")
    @post.stub!(:in_draft).and_return(false)
    @post.stub!(:tags).and_return([])  
    @post.stub!(:comments).and_return([])  
    assigns[:post] = @post
  end

  it "should render an individual post" do
    render "/admin/posts/show.html.erb"
    response.should have_text(/MyString/)
    response.should have_text(/MyString/)
    response.should have_text(/MyText/)
    response.should have_text(/MyText/)
    response.should have_text(/MyText/)
    response.should have_text(/als/)
  end
end

