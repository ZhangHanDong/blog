require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/blogs/index" do
  
  include ApplicationHelper
  include BlogsHelper
  
  
  before(:each) do
    blog_1 = mock_model(Blog, :title => 'Blog Title 1')
    blog_2 = mock_model(Blog, :title => 'Blog Title 2')
    assigns[:blogs] = [blog_1, blog_2]
    assigns[:blogs].stub!(:total_pages).and_return(0)
  end
  
  it "should render list of blogs" do
    render 'blogs/index' 
  end
  
end
