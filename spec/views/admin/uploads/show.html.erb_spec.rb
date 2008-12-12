require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "/uploads/show.html.erb" do
  include Admin::UploadsHelper
  
  before(:each) do
    @blog = mock_model(Blog)
    @upload = Upload.create!({
      :asset => fixture_file_upload('files/50x50.png', 'image/png'),
      :blog_id => 1,
      :user_id => 1
    })
    assigns[:blog] = @blog
    assigns[:upload] = @upload
  end

  it "should render attributes in <p>" do
    render "/admin/uploads/show.html.erb"
    response.should have_text(/original_50x50.png/)
  end
end

