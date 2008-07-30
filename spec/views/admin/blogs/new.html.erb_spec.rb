require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "/admin/blogs/new.html.erb" do
  include Admin::BlogsHelper
  
  before(:each) do
    @blog = mock_model(Blog)
    @blog.stub!(:new_record?).and_return(true)
    @blog.stub!(:title).and_return("MyString")
    assigns[:blog] = @blog
  end

  it "should render new form" do
    render "/admin/blogs/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", admin_blogs_path) do
      with_tag("input#blog_title[name=?]", "blog[title]")
    end
  end
end


