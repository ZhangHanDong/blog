require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "/admin/blogs/show.html.erb" do
  include Admin::BlogsHelper
  
  before(:each) do
    @user = mock_model(User)
    @blog = mock_model(Blog)
    @blog.stub!(:title).and_return("MyString")
    @blog.stub!(:short_name).and_return("MyString")
    @blog.stub!(:in_draft).and_return(false)
    @blog.stub!(:creator).and_return(@user)
    
    @user.stub!(:name).and_return('Cowboy Joe')
    assigns[:blog] = @blog
  end

  it "should show blog attributes" do
    render "/admin/blogs/show.html.erb"
    response.should have_text(/MyString/)
  end
end

