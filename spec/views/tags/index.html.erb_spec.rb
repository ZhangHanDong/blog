require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/tags/index" do
  
  include ApplicationHelper
  include TagsHelper
  
  before(:each) do
    @blog_1 = mock_model(Blog, :title => 'Blog Title 1')
    @tag_1 =  mock_model(Tag, :name => 'tag1')
    @tag_2 =  mock_model(Tag, :name => 'tag2')       
    @tag_3 =  mock_model(Tag, :name => 'tag3 with space') 
    
    @tag_1.stub!(:blog_taggings_count).and_return(1)
    @tag_2.stub!(:blog_taggings_count).and_return(1)
    @tag_3.stub!(:blog_taggings_count).and_return(1)
    
    assigns[:blog] = @blog_1
    assigns[:tags] = [@tag_1, @tag_2, @tag_3]
    assigns[:tags].stub!(:total_pages).and_return(0)
  end
  
  it "should render list of tags with blog tag name paths" do
    render 'tags/index' 
    response.should have_tag('a[href=?]', "http://test.host/blogs/#{@blog_1.id}/tag1")
    response.should have_tag('a[href=?]', "http://test.host/blogs/#{@blog_1.id}/tag2")
    response.should have_tag('a[href=?]', "http://test.host/blogs/#{@blog_1.id}/tag3_with_space")
  end      
  
end
