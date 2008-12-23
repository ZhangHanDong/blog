require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module PostSweeperSpecHelper

  def valid_post_attributes
    {
      :title => 'Post Title',
      :publish_date => Date.today,
      :body => 'Phasellus pulvinar, nulla non *aliquam* eleifend, "tortor":http://google.com wisi scelerisque felis, in sollicitudin arcu ante lacinia leo.',
      :in_draft => false,
      :user_id => 1,
      :blog_id => 1
    }
  end

end


describe PostSweeper do

  include PostSweeperSpecHelper

  before(:each) do
    @sweeper = PostSweeper.instance
  end


  describe "after create (no tags)" do

    before(:each) do
      @post = Post.new(valid_post_attributes)
    end

    it "should expire when not in draft" do
      @sweeper.should_receive(:expire_all).with(@post, true)
      @post.save!
    end

    it "should not expire if in draft and not changed" do
      @sweeper.should_not_receive(:expire_all).with(@post)
      @post.in_draft = true
      @post.save!
    end

  end


  describe "after create (with tags)" do

    before(:each) do
      @post = Post.new(valid_post_attributes.with(:tag_list => 'one "two tag"'))
    end

    it "should expire when not in draft" do
      @sweeper.should_receive(:expire_all).with(@post, true)
      @sweeper.should_receive(:expire_all).with(@post)
      @post.save!
    end

  end


  describe "after update" do

    it "should not expire when not changed" do
      @post = Post.create!(valid_post_attributes)
      @sweeper.should_not_receive(:expire_all).with(@post)
      @post.save!
    end

    it "should not expire when changed and already in draft" do
      @post = Post.create!(valid_post_attributes.with(:in_draft => true))
      @sweeper.should_not_receive(:expire_all).with(@post)
      @post.title = "new title"
      @post.save!
    end

    it "should expire when changed and not in draft" do
      @post = Post.create!(valid_post_attributes)
      @sweeper.should_receive(:expire_all).with(@post)
      @post.title = "new title"
      @post.save!
    end

    it "should expire when draft status changed" do
      @post = Post.create!(valid_post_attributes.with(:in_draft => true))
      @sweeper.should_receive(:expire_all).with(@post)
      @post.in_draft = false
      @post.save!
    end

  end


  describe "after destroy (with tags)" do

    before(:each) do
      @post = Post.create!(valid_post_attributes.with(:tag_list => 'one "two tag"'))
    end

    it "should always expire" do 
      require 'ruby-debug'
      debugger
      @sweeper.should_receive(:expire_all).with(@post, false, true)
      @post.destroy
    end

  end

end