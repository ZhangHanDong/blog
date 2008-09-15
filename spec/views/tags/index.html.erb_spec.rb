require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/tags/index" do
  
  include ApplicationHelper
  include TagsHelper
  
  before(:each) do
    blog_1 = mock_model(Blog, :title => 'Blog Title 1')
    tag_1 =  mock_model(Tag, :name => 'Tag1')
    tag_2 =  mock_model(Tag, :name => 'Tag2')       
    
    assigns[:blog] = blog_1
    assigns[:tags] = [tag_1, tag_2]
    assigns[:tags].stub!(:total_pages).and_return(0)
  end
  
  it "should render list of tags" do
    render 'tags/index' 
    response.should have_tag("h1",  :text => "Blog Title 1 tags")
  end      
  
end
