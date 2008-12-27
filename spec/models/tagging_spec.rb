require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module TaggingSpecHelper

  def valid_post_attributes(blog, tag_list)
    {
      :title => 'Post Title',
      :publish_date => Date.today,
      :body => 'Phasellus pulvinar, nulla non *aliquam* eleifend, "tortor":http://google.com wisi scelerisque felis, in sollicitudin arcu ante lacinia leo.',
      :in_draft => false,
      :user_id => 1,
      :tag_list => tag_list,
      :blog => blog
    }
  end

end


describe Tagging do

  include TaggingSpecHelper


  before(:each) do
    @blog_1 = Blog.create!(:title => 'The Film Talk', :short_name => 'filmtalk',
    :created_by_id => 1)

    @blog_2 = Blog.create!(:title => 'The LTA', :short_name => 'lta',
    :created_by_id => 1)
  end


  describe 'being associated with' do

    it "should belong a blog" do
      Post.create!(valid_post_attributes(@blog_1, 'one two'))
      Post.create!(valid_post_attributes(@blog_2, 'one three'))

      @tag = Tag.find_by_name('one')
      @tag.taggings.first.blog.should eql(@blog_1)

      @tag = Tag.find_by_name('three')
      @tag.taggings.first.blog.should eql(@blog_2)
    end

  end

end