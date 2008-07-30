require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module BlogSpecHelper

  def valid_blog_attributes
    {
      :title => 'The Film Talk'
    }
  end

end

describe Blog do
  fixtures :blogs

  include BlogSpecHelper

  before(:each) do
    @blog = Blog.new
  end
          
  
  describe 'being validated' do

    it "should be valid" do
      @blog.attributes = valid_blog_attributes
      @blog.should be_valid
    end
     
    it "should have an error on title" do
      @blog.attributes = valid_blog_attributes.except(:title)
      @blog.should have(1).error_on(:title)
    end
    
  end
end
