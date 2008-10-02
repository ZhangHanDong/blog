require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "/uploads/edit.html.erb" do
  include Admin::UploadsHelper
  
  before do
    @upload = mock_model(Upload)
    @upload.stub!(:title).and_return("MyString")
    @upload.stub!(:blog_id).and_return("1")
    @upload.stub!(:user_id).and_return("1")
    assigns[:upload] = @upload
  end

  it "should render edit form" do
    render "/admin/uploads/edit.html.erb"
    
    response.should have_tag("form[action=#{admin_upload_path(@upload)}][method=post]") do
      with_tag('input#upload_title[name=?]', "upload[title]")
    end
  end
end


