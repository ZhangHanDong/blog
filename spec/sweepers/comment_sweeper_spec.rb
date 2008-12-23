require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module CommentSweeperSpecHelper

  def valid_comment_attributes
    {
      :name => 'Jon Johnsson',
      :body => 'Phasellus pulvinar, nulla non *aliquam* eleifend, "tortor":http://google.com wisi scelerisque felis, in sollicitudin arcu ante lacinia leo.',
      :spam_question_id => 1,
      :spam_answer => 'cold'
    }
  end

end


describe CommentSweeper do

  include CommentSweeperSpecHelper

  before(:each) do
    @sweeper = CommentSweeper.instance
    @post = Post.create!(:title => 'Post Title', :publish_date => Date.today,
    :body => 'test', :user_id => 1, :blog_id => 1)
  end


  describe "after create" do

    before(:each) do
      @comment = @post.comments.new(valid_comment_attributes)
    end

    it "should always expire" do
      @sweeper.should_receive(:expire_all).with(@comment)
      @comment.save!
    end

  end


  describe "after update" do

    before(:each) do
      @comment = @post.comments.create!(valid_comment_attributes)
    end

    it "should not expire when not changed" do
      @sweeper.should_not_receive(:expire_all).with(@comment)
      @comment.save!
    end

    it "should expire when changed" do
      @sweeper.should_receive(:expire_all).with(@comment)
      @comment.body = "something new to say"
      @comment.save!
    end

  end


  describe "after destroy" do

    before(:each) do
      @comment = @post.comments.create!(valid_comment_attributes)
    end

    it "should always expire" do
      @sweeper.should_receive(:expire_all).with(@comment)
      @comment.destroy
    end

  end

end