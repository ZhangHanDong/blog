require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "/admin/posts/edit.html.erb" do
  include Admin::PostsHelper
  
  before do                      
    @blog = mock_model(Blog, :title => 'Blog Title')
    @post = mock_model(Post)               
    @post.stub!(:blog).and_return(@blog)        
    @post.stub!(:blog_id).and_return(@blog.id) 
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

  it "should render edit post form" do
    render "/admin/posts/edit.html.erb"
    
    response.should have_tag("form[action=#{admin_blog_post_path(@blog, @post)}][method=post]")
    response.should have_tag('input#post_title[name=?]', "post[title]")
    response.should have_tag('textarea#post_summary[name=?]', "post[summary]")
    response.should have_tag('textarea#post_body[name=?]', "post[body]") 
    response.should have_tag('input#post_in_draft[name=?]', "post[in_draft]")
  end
end


