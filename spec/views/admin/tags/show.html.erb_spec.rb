require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "/admin/tags/show" do
  include Admin::TagsHelper
  
  before(:each) do
    @tag = mock_model(Post)
    @tag.stub!(:name).and_return("MyString")
    @tag.stub!(:taggings).and_return([])
    assigns[:tag] = @tag
  end

  it "should render attributes" do
    render "/admin/tags/show.html.erb"
    response.should have_text(/MyString/)
  end
end
