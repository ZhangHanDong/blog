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

    it "should expire old permalink with title change" do
      @post = Post.create!(valid_post_attributes)
      @sweeper.should_receive(:expire_page).once.with({:controller=>"/posts",
                                                  :day => @post.publish_date.day,
                                                  :month => @post.publish_date.month,
                                                  :permalink => "post-title",
                                                  :year => @post.publish_date.year,
                                                  :action => "permalink"})


      @sweeper.should_receive(:expire_page).with({:controller=>"/comments",
                                                  :post_id => @post.id, :action => "index"})
                                                  
      @sweeper.should_receive(:expire_page).with({:controller=>"/comments",
                                                  :post_id => @post.id, :action => "index",
                                                  :format=>:atom})

      @sweeper.should_receive(:expire_page).with({:controller=>"/posts",
                                                  :day => @post.publish_date.day,
                                                  :month => @post.publish_date.month,
                                                  :year => @post.publish_date.year,
                                                  :action=>"on"})

      @sweeper.should_receive(:expire_page).with({:controller=>"/posts",
                                                  :month=>@post.publish_date.month,
                                                  :year=>@post.publish_date.year, :action=>"on"})

      @sweeper.should_receive(:expire_page).with({:controller=>"/posts",
                                                  :year=>@post.publish_date.year, :action=>"on"})
                                                  
      @sweeper.should_receive(:expire_page).with({:controller=>"/posts",
                                                  :blog_id=>@post.blog_id, :action=>"index"})
                                                  
      @sweeper.should_receive(:expire_page).with({:controller=>"/posts",
                                                  :blog_id=>@post.blog_id, 
                                                  :action=>"index", :format=>:atom})
                                                  
      @sweeper.should_receive(:expire_page).with({:controller=>"/posts", :user_id=>@post.user_id,
                                                  :blog_id=>@post.blog_id, :action=>"index"})

      @sweeper.should_receive(:expire_page).with({:controller=>"/posts", :format=>:atom,
                                                  :user_id=>@post.user_id, :blog_id=>@post.blog_id,
                                                  :action=>"index"})

      @post.title = "new title"
      @post.save!
    end

  end


  describe "after destroy (with tags)" do

    before(:each) do
      @post = Post.create!(valid_post_attributes.with(:tag_list => 'one "two tag"'))
    end

    it "should always expire" do
      current_tags = Tag.parse(@post.cached_tag_list)
      @sweeper.should_receive(:expire_tag_pages).with(@post, current_tags)
      @post.destroy
    end

  end

end