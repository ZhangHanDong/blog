require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "/uploads/new.html.erb" do
  include Admin::UploadsHelper
  
  before(:each) do
    @upload = mock_model(Upload)
    @upload.stub!(:new_record?).and_return(true)
    @upload.stub!(:title).and_return("MyString")
    @upload.stub!(:blog_id).and_return("1")
    @upload.stub!(:user_id).and_return("1")
    assigns[:upload] = @upload
  end

  it "should render new form" do
    render "/admin/uploads/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", admin_uploads_path) do
      with_tag("input#upload_title[name=?]", "upload[title]")
    end
  end
end


