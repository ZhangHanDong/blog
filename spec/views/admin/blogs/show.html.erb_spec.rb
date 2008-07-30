require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "/admin/blogs/show.html.erb" do
  include Admin::BlogsHelper
  
  before(:each) do
    @blog = mock_model(Blog)
    @blog.stub!(:title).and_return("MyString")

    assigns[:blog] = @blog
  end

  it "should render attributes in <p>" do
    render "/admin/blogs/show.html.erb"
    response.should have_text(/MyString/)
  end
end

