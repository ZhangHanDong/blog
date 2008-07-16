require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "/admin/posts/index.html.erb" do
  include Admin::PostsHelper
  
  before(:each) do
    post_98 = mock_model(Post)
    post_98.should_receive(:title).and_return("MyString")
    post_98.should_receive(:publish_date).and_return(Time.now)
    post_98.should_receive(:in_draft).and_return(false)
    post_98.should_receive(:user).and_return(false)   
    post_98.should_receive(:comments).twice.and_return([])
    post_99 = mock_model(Post)
    post_99.should_receive(:title).and_return("MyString")
    post_99.should_receive(:publish_date).and_return(Time.now)
    post_99.should_receive(:in_draft).and_return(false)
    post_99.should_receive(:user).and_return(false) 
    post_99.should_receive(:comments).twice.and_return([]) 
    assigns[:posts] = [post_98, post_99]
    assigns[:posts].stub!(:total_pages).and_return(0)
  end

  it "should render list of posts" do
    render "/admin/posts/index.html.erb"
    response.should have_tag("tr>td", "MyString", 2)
    response.should have_tag("tr>td", "MyString", 2)
  end
end

