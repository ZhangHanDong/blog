require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Upload do
  before(:each) do
    @upload = Upload.new
    @upload.asset = Object.new
  end

  it "should be valid"
end
