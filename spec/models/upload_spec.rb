require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module UploadSpecHelper
  
  def valid_upload_attributes
    {
      
    }
  end
  
end

describe Upload do

  fixtures :users
  
  include UploadSpecHelper

  before(:each) do
    @upload = Upload.new
    @upload.asset = Object.new
  end


  describe 'named scopes' do

    it "should have a recent scope, and find recent uploads"
    it "should have a by user scope, and find uploads by a user"

  end
  
  
  describe 'being associated with' do

    it "should belong to a user"
    it "should belong to a blog"
    
  end

  
  describe 'being validated' do

     it "should be valid"
     it "should have an asset"
     
  end


end
