require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "/uploads/show.html.erb" do
  include Admin::UploadsHelper
  
  before(:each) do
    @upload = mock_model(Upload)
    @upload.stub!(:title).and_return("MyString")
    @upload.stub!(:blog_id).and_return("1")
    @upload.stub!(:user_id).and_return("1")

    assigns[:upload] = @upload
  end

  it "should render attributes in <p>" do
    render "/admin/uploads/show.html.erb"
    response.should have_text(/MyString/)
  end
end

