require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "/uploads/index.html.erb" do
  include Admin::UploadsHelper
  
  before(:each) do
    @blog = mock_model(Blog, :title => 'blog title')
    upload_98 = mock_model(Upload)
    upload_98.should_receive(:asset_content_type)
    upload_98.should_receive(:asset_file_name)
    upload_99 = mock_model(Upload)
    upload_99.should_receive(:asset_content_type)
    upload_99.should_receive(:asset_file_name)

    assigns[:blog] = @blog
    assigns[:uploads] = [upload_98, upload_99]
    assigns[:upload] =  Upload.new
    assigns[:uploads].stub!(:total_pages).and_return(0)
  end

  it "should render list of uploads" do
    render "/admin/uploads/index.html.erb"
  end
end

