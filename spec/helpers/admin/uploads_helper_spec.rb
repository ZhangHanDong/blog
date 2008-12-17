require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Admin::UploadsHelper do
  
  include Admin::UploadsHelper


  describe "truncate filename method" do  
    
    it "should shorten a long filename to show start, end and extension \ 
        (with default seperator between)" do
      truncate_filename('iamalongfilenamewithanextension.jpg').should eql('iamalo...on.jpg')
    end
    
    it "should not shorten a short filename" do
      truncate_filename('12345.jpg').should eql('12345.jpg')
    end
    
    it "should allow length and seperator to be set" do
      truncate_filename('123456789101112.jpg', 10, '******').should eql('1234567891******12.jpg')
    end
    
  end
  
end