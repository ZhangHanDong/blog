require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Upload do
  before(:each) do
    @upload = Upload.new
  end

  it "should be valid" do
    @upload.should be_valid
  end
end
