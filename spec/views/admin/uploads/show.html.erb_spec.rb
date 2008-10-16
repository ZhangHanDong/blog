require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "/uploads/show.html.erb" do
  include Admin::UploadsHelper
  
  before(:each) do
    @upload = mock_model(Upload)
    @user = mock_model(User, :name => 'jack')
    
    @asset = Object.new
    @asset.stub!(:url).and_return("something/thing.jpg")
    @upload.stub!(:title).and_return("MyString")
    @upload.stub!(:blog_id).and_return("1")
    @upload.stub!(:user_id).and_return("1")
    @upload.should_receive(:asset).at_least(1).times.and_return(@asset)
    @upload.should_receive(:asset_file_name)
    @upload.should_receive(:asset_content_type)
    @upload.should_receive(:asset_file_size)
    @upload.should_receive(:user).at_least(1).times.and_return(@user)
    @upload.should_receive(:created_at).and_return(Time.now)

    assigns[:upload] = @upload
  end

  it "should render attributes in <p>" do
    render "/admin/uploads/show.html.erb"
    response.should have_text(/something\/thing.jpg/)
  end
end

