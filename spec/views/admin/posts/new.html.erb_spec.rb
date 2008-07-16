require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "/admin/posts/new.html.erb" do
  include Admin::PostsHelper
  
  before(:each) do
    @post = mock_model(Post)             
    @post.stub!(:new_record?).and_return(true)
    @post.stub!(:title).and_return("MyString")
    @post.stub!(:permalink).and_return("MyString")
    @post.stub!(:publish_date).and_return(Time.now)
    @post.stub!(:summary).and_return("MyText")
    @post.stub!(:body).and_return("MyText")
    @post.stub!(:body_formatted).and_return("MyText")
    @post.stub!(:tags).and_return([]) 
    @post.stub!(:tag_list).and_return("")
    @post.stub!(:in_draft).and_return(false)   
    assigns[:post] = @post
  end

  it "should render new post form" do
    render "/admin/posts/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", admin_posts_path) do
      with_tag("input#post_title[name=?]", "post[title]")
      with_tag("textarea#post_summary[name=?]", "post[summary]")
      with_tag("textarea#post_body[name=?]", "post[body]")   
      with_tag("input#post_in_draft[name=?]", "post[in_draft]")
    end
  end
end


