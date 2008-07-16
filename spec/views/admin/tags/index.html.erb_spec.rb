require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "/admin/tags/index" do
  include Admin::TagsHelper
  
  before(:each) do
    tag_98 = mock_model(Tag)
    tag_98.should_receive(:name).and_return("MyString")   
    tag_98.should_receive(:taggings_count).at_least(2).times.and_return(1)   
    tag_99 = mock_model(Tag)
    tag_99.should_receive(:name).and_return("MyString") 
    tag_99.should_receive(:taggings_count).at_least(2).times.and_return(2)
    assigns[:tags] = [tag_98, tag_99]
    assigns[:tags].stub!(:total_pages).and_return(0)
  end

  it "should render list of tags" do
    render "/admin/tags/index.html.erb"
    response.should have_tag("tr>td", "MyString", 2)
    response.should have_tag("tr>td", "MyString", 2)
  end
end
