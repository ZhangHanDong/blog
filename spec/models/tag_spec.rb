require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module TagSpecHelper

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


describe Tag do

  include TagSpecHelper
  
  
  before(:each) do
    @blog_1 = Blog.create!(:title => 'The Film Talk', :short_name => 'filmtalk',
                           :created_by_id => 1)

    @blog_2 = Blog.create!(:title => 'The LTA', :short_name => 'lta',
                           :created_by_id => 1)
  end


  describe 'named scopes' do

    it "should have a by user scope that returns tags created by a user" do
      Tag.should have_named_scope(:by_user, {:include=>:taggings,
      :conditions=>["taggings.user_id = ?", []]})
    end

    it "should have a recent scope that returns up to 20 tags ordered by id DESC" do
      Tag.should have_named_scope(:recent, {:limit=>20, :order=>"tags.id DESC"})
    end

  end


  describe 'being associated with' do

    it "should have blogs" do
      Post.create!(valid_post_attributes(@blog_1, 'one two'))
      Post.create!(valid_post_attributes(@blog_2, 'one three'))
      
      @tag = Tag.find_by_name('one')
      @tag.blogs.should eql([@blog_1, @blog_2])
       
      @tag = Tag.find_by_name('three')
      @tag.blogs.should eql([@blog_2])                            
    end

  end


  describe 'tagging count' do

    it "should count taggings for a tag" do
      Post.create!(valid_post_attributes(@blog_1, 'one two'))
      Post.create!(valid_post_attributes(@blog_1, 'one two'))
      Post.create!(valid_post_attributes(@blog_2, 'two three'))

      @tag = Tag.find_by_name('one')
      @tag.blog_taggings_count(@blog_1).should eql(2)
      @tag.blog_taggings_count(@blog_2).should eql(0)

      @tag = Tag.find_by_name('three')
      @tag.blog_taggings_count(@blog_1).should eql(0)
      @tag.blog_taggings_count(@blog_2).should eql(1)
    end

  end

end