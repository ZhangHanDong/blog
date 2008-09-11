require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "/admin/tags/show" do
  include Admin::TagsHelper
  
  before(:each) do   
    @blog = mock_model(Blog, :title => 'Blog Title')
    @tag = mock_model(Post)
    @tag.stub!(:name).and_return("MyString")
    @tag.stub!(:taggings).and_return([])
    assigns[:blog] = @blog  
    assigns[:tag] = @tag
  end

  it "should render all items tagged with this tag" do
    render "/admin/tags/show.html.erb"
    response.should have_text(/MyString/)
  end
end
