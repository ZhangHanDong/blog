require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module BlogSweeperSpecHelper

  def valid_blog_attributes
    {
      :title => 'The Film Talk',
      :short_name => 'filmtalk',
      :created_by_id => 1,
      :in_draft => false
    }
  end

end


describe BlogSweeper do

  include BlogSweeperSpecHelper

  before(:each) do
    @sweeper = BlogSweeper.instance
  end


  describe "after create" do

    before(:each) do
      @blog = Blog.new(valid_blog_attributes)
    end

    it "should expire when not in draft" do
      @sweeper.should_receive(:expire_all).with(@blog, true)
      @blog.save!
    end

    it "should not expire if in draft and not changed" do
      @sweeper.should_not_receive(:expire_all).with(@blog, true)
      @blog.in_draft = true
      @blog.save!
    end

  end


  describe "after update" do

    it "should not expire when not changed" do
      @blog = Blog.create!(valid_blog_attributes)
      @sweeper.should_not_receive(:expire_all).with(@blog)
      @blog.save!
    end

    it "should not expire when changed and already in draft" do
      @blog = Blog.create!(valid_blog_attributes.with(:in_draft => true))
      @sweeper.should_not_receive(:expire_all).with(@blog)
      @blog.title = "new title"
      @blog.save!
    end

    it "should expire when changed and not in draft" do
      @blog = Blog.create!(valid_blog_attributes)
      @sweeper.should_receive(:expire_all).with(@blog)
      @blog.title = "new title"
      @blog.save!
    end

    it "should expire when draft status changed" do
      @blog = Blog.create!(valid_blog_attributes.with(:in_draft => true))
      @sweeper.should_receive(:expire_all).with(@blog)
      @blog.in_draft = false
      @blog.save!
    end

  end


  describe "after destroy" do

    before(:each) do
      @blog = Blog.create!(valid_blog_attributes)
    end

    it "should always expire" do
      @sweeper.should_receive(:expire_all).with(@blog)
      @blog.destroy
    end

  end

end
