require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SweepingHelper do
  
  include SweepingHelper
  
  it "should sweep path, deleteing files in path" do
    FileUtils.should_receive(:rm_r)
    RAILS_DEFAULT_LOGGER.should_receive(:info).with("Expired path: blogs/1")
    SweepingHelper::sweep_path("blogs/1")
  end

end