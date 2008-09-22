require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/tags/index" do
  
  include ApplicationHelper
  include TagsHelper
  
  before(:each) do
    @blog_1 = mock_model(Blog, :title => 'Blog Title 1')
    @tag_1 =  mock_model(Tag, :name => 'tag1')
    @tag_2 =  mock_model(Tag, :name => 'tag2')       
    @tag_3 =  mock_model(Tag, :name => 'tag3 with space and funky chars, (â Â, ê Ê, î Î, ô Ô, û Û, ŵ)') 
    
    assigns[:blog] = @blog_1
    assigns[:tags] = [@tag_1, @tag_2, @tag_3]
    assigns[:tags].stub!(:total_pages).and_return(0)
  end
  
  it "should render list of tags with blog tag name paths" do
    render 'tags/index' 
    response.should have_tag("h1",  :text => "Blog Title 1 tags")
    response.should have_tag('a[href=?]', "/blogs/#{@blog_1.id}/tag1")
    response.should have_tag('a[href=?]', "/blogs/#{@blog_1.id}/tag2")
    response.should have_tag('a[href=?]', "/blogs/#{@blog_1.id}/tag3_with_space_and_funky_chars,_(â_Â,_ê_Ê,_î_Î,_ô_Ô,_û_Û,_ŵ)")
  end      
  
end
