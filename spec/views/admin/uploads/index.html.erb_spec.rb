require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "/uploads/index.html.erb" do
  include Admin::UploadsHelper
  
  before(:each) do
    upload_98 = mock_model(Upload)
    upload_98.should_receive(:title).and_return("MyString")
    upload_98.should_receive(:blog_id).and_return("1")
    upload_98.should_receive(:user_id).and_return("1")
    upload_99 = mock_model(Upload)
    upload_99.should_receive(:title).and_return("MyString")
    upload_99.should_receive(:blog_id).and_return("1")
    upload_99.should_receive(:user_id).and_return("1")

    assigns[:uploads] = [upload_98, upload_99]
    assigns[:upload] =  Upload.new
  end

  it "should render list of uploads" do
    render "/admin/uploads/index.html.erb"
    response.should have_tag("tr>td", "MyString", 2)
  end
end

