require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module UploadSpecHelper

  def valid_upload_attributes
    {
      :asset => fixture_file_upload('files/50x50.png', 'image/png'),
      :blog_id => 1,
      :user_id => 1
    }
  end
end


describe Upload do

  fixtures :users

  include UploadSpecHelper

  before(:each) do
    @upload = Upload.new
  end


  describe 'named scopes' do

    it "should have a by user scope, and find uploads by a user" do
      Upload.should have_named_scope(:by_user, {:conditions=>["uploads.user_id = ?", []]})
    end

    it "should have a recent scope that returns up to 20 uploads ordered by created_at DESC" do
      Upload.should have_named_scope(:recent, {:limit=>20, :order=>"uploads.created_at DESC"})
    end

  end


  describe 'being associated with' do

    it "should belong to a user" do
      @upload.attributes = valid_upload_attributes
      @upload.save!
      @upload.user.should eql(users(:quentin))
    end

    it "should belong to a blog" do
      @blog = Blog.create!(:title => 'test', :short_name => 'test', :created_by_id => 1)
      @upload.attributes = valid_upload_attributes.with(:blog => @blog)
      @upload.save!
      @upload.blog.should eql(@blog)
    end

  end


  describe 'being validated' do

    it "should be valid" do
      @upload.attributes = valid_upload_attributes
      @upload.should be_valid
    end

    it "should have an error on missing asset" do
      @upload.attributes = valid_upload_attributes.except(:asset)
      @upload.should have(1).error_on(:asset)
    end

    it "should have an error on not allowed file type" do
      @upload.attributes = valid_upload_attributes.with(:asset => fixture_file_upload('files/50x50.png', 'image/x-png'))
      @upload.should have(1).error_on(:asset)
    end

    it "should have an error on missing user" do
      @upload.attributes = valid_upload_attributes.except(:user_id)
      @upload.should have(1).error_on(:user_id)
    end

  end

end