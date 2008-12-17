require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module CommentSpecHelper

  def valid_comment_attributes
    {
      :name => 'Jon Johnsson',
      :body => 'Phasellus pulvinar, nulla non *aliquam* eleifend, "tortor":http://google.com wisi scelerisque felis, in sollicitudin arcu ante lacinia leo.',
      :post_id => 1,
      :spam_question_id => 1,
      :spam_answer => 'cold'
    }
  end

end


describe Comment do

  include CommentSpecHelper

  before(:each) do
    @comment = Comment.new
    @post = Post.create!(:title => 'Post Title', :publish_date => Date.today,
                         :body => 'test', :user_id => 1, :blog_id => 1)
    @comment.post = @post
  end


  describe 'named scopes' do

    it "should have a recent scope that returns up to 20 comments ordered by created at DESC" do
      Comment.should have_named_scope(:recent, {:limit => 20,
                                                :order => "comments.created_at DESC"})
    end

    it "should have a by_user scope that returns comments created by a user" do
      Comment.should have_named_scope(:by_user, {:conditions=>["comments.user_id = ?", []]})
    end

    it "should have a published scope that returns comments \
        only on posts that have in_draft set to false" do
      Comment.should have_named_scope(:published, {:include => :post,
                                                   :conditions => ["posts.in_draft = ?", false]})
    end

  end


  describe 'being associated with' do

    it "should belong to a user" do
      @comment.attributes = valid_comment_attributes.with(:user_id => 1)
      @comment.save!
    end

    it "should belong to a post" do
      @comment.attributes = valid_comment_attributes
      @comment.save!
      @comment.post.should eql(@post)
    end

  end


  describe "helper methods" do

    it "should return a random spam question from those defined in application config" do
      APP_CONFIG['spam_questions'].select { |q|
        q == Comment.random_spam_question
      }.should_not be_nil
    end

  end


  describe 'before save callbacks' do

    it "should format the website url after saving (create)" do
      @comment.attributes = valid_comment_attributes.with(:website => 'www.yahoo.com')
      @comment.save!
      @comment.website.should eql('http://www.yahoo.com')
    end

    it "should format the website url after saving (update)" do
      @comment.attributes = valid_comment_attributes.with(:website => 'something.matt.com')
      @comment.save!
      @comment.update_attribute(:website, 'https://matt.com')
      @comment.website.should eql('https://matt.com')
    end

  end


  describe "spam protection" do

    it "should error on an invalid answer to the spam question during validate" do
      @comment.attributes = valid_comment_attributes.with(:spam_question_id => 1,
                                                          :spam_answer => 'bananas')
      @comment.should have(1).error_on(:base)
    end

    it "should be valid with a correct answer to the spam question" do
      @comment.attributes = valid_comment_attributes.with(:spam_question_id => 1,
                                                          :spam_answer => 'cold')
      @comment.should be_valid
    end

    it "should be valid with a case-insensitive string answer to the spam question" do
      @comment.attributes = valid_comment_attributes.with(:spam_question_id => 1,
                                                          :spam_answer => '  it is cOlD! ewfw  ')
      @comment.should be_valid
    end

  end


  describe 'being validated' do

    it "should be valid" do
      @comment.attributes = valid_comment_attributes
      @comment.should be_valid
    end

    it "should have an error on name" do
      @comment.attributes = valid_comment_attributes.except(:name)
      @comment.should have(1).error_on(:name)
    end

    it "should have an error on body" do
      @comment.attributes = valid_comment_attributes.except(:body)
      @comment.should have(1).error_on(:body)
    end

    it "should have an error on no post" do
      @comment.post = nil
      @comment.should have(1).error_on(:post_id)
    end

    it "should have an valid email if passed" do
      @comment.attributes = valid_comment_attributes.with(:email => 'something@that.com')
      @comment.should have(0).errors_on(:email)
    end

    it "should raise invalid email error" do
      @comment.attributes = valid_comment_attributes.with(:email => 'som.eth.ingwqdo!!that.com')
      @comment.should have(1).error_on(:email)
    end

  end

end