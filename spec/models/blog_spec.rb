require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module BlogSpecHelper

  def valid_blog_attributes
    {
      :title => 'The Film Talk',
      :short_name => 'filmtalk',
      :created_by_id => 1,
      :in_draft => false
    }
  end

end

describe Blog do
  
  fixtures :blogs, :users

  include BlogSpecHelper

  before(:each) do
    @blog = Blog.new
  end
  
  
  describe 'named scopes' do

    it "should have a published scope that returns blogs with in_draft flag set to false" do
      Blog.should have_named_scope(:published, {:conditions => {:in_draft => false}})
    end
    
  end
         
         
  describe 'being associated with' do

    it "should have a creator" do
      @blog.attributes = valid_blog_attributes.with(:created_by_id => 1)
      @blog.save!
      @blog.creator.should eql(users(:quentin))
    end
    
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
    
    it "should have an error on short_name" do
      @blog.attributes = valid_blog_attributes.except(:short_name)
      @blog.should have(1).error_on(:short_name)
    end
    
    it "should have an error on created_by_id" do
      @blog.attributes = valid_blog_attributes.except(:created_by_id)
      @blog.should have(1).error_on(:created_by_id)
    end
    
    it "should have an error on short_name format (alphanumeric only)" do
      @blog.attributes = valid_blog_attributes.with(:short_name => '_+_+!hello!')
      @blog.should have(1).error_on(:short_name)
    end
    
    it "should have an error on short_name length" do
      @blog.attributes = valid_blog_attributes.with(:short_name => 'kwjebdeiuwfdiewvcfjkewbbecfiuewgegfiu2ebvjkwbbewiuewcfjewhwekjnbdejkwbdidieuwbddeiwdeiwewdneiwueudiuewhdiewjbdkewjbd')
      @blog.should have(1).error_on(:short_name)
    end
    
    it "should have an error on short_name being unique" do
      @blog.attributes = valid_blog_attributes
      @blog.save!
      @blog_again = Blog.create(valid_blog_attributes.with(:short_name => 'filmtalk'))
      @blog_again.should have(1).error_on(:short_name)
    end
  end
end
