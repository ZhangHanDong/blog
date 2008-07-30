require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "/admin/blogs/index.html.erb" do
  include Admin::BlogsHelper
  
  before(:each) do
    blog_98 = mock_model(Blog)
    blog_98.should_receive(:title).and_return("MyString")
    blog_99 = mock_model(Blog)
    blog_99.should_receive(:title).and_return("MyString")

    assigns[:blogs] = [blog_98, blog_99]
  end

  it "should render list of blogs" do
    render "/admin/blogs/index.html.erb"
    response.should have_tag("tr>td", "MyString", 2)
  end
end

