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

  it "should render list of uploads for blog with upload form" do
    render "/admin/uploads/index.html.erb"
    response.should have_tag("form[action=?][method=post]", admin_blog_uploads_path(@blog))
  end
  
  it "should show uploads by user in blog (and no upload form)" do
    @user = mock_model(User)
    assigns[:user] = @user
    @user.stub!(:name).and_return('Jett')
    render "/admin/uploads/index.html.erb"
    response.should_not have_tag("form[action=?][method=post]", admin_blog_uploads_path(@blog))
    response.should have_tag("a", "upload new file to blog title")
  end
  
end

