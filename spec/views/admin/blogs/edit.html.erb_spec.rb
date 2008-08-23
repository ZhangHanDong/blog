require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "/admin/blogs/edit.html.erb" do
  include Admin::BlogsHelper
  
  before do
    @blog = mock_model(Blog)
    @blog.stub!(:title).and_return("MyString")
    @blog.stub!(:short_name).and_return("MyString")
    @blog.stub!(:in_draft).and_return(false)
    assigns[:blog] = @blog
  end

  it "should render edit form" do
    render "/admin/blogs/edit.html.erb"
    
    response.should have_tag("form[action=#{admin_blog_path(@blog)}][method=post]") do
      with_tag('input#blog_title[name=?]', "blog[title]")
    end
  end
end


