require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "/admin/tags/index" do
  include Admin::TagsHelper
  
  before(:each) do 
    blog = mock_model(Blog, :title => 'Blog Title')
    
    tag_98 = mock_model(Tag)
    tag_99 = mock_model(Tag)
    
    tag_98.should_receive(:name).and_return("MyString")   
    tag_99.should_receive(:name).and_return("MyString2") 
    
    tag_98.should_receive(:blog_taggings_count).with(blog).and_return(1)
    tag_99.should_receive(:blog_taggings_count).with(blog).and_return(2)
    
    assigns[:blog] = blog
    assigns[:tags] = [tag_98, tag_99]
    assigns[:tags].stub!(:total_pages).and_return(0)
  end

  it "should render list of tags" do
    render "/admin/tags/index.html.erb"              
    response.should have_tag("h1",  :text => "Blog Title tags") 
    response.should have_tag("tr>td", "MyString (1 times)")
    response.should have_tag("tr>td", "MyString2 (2 times)")
  end
end
