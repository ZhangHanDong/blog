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

  def create_blog_post_comment(short_name, comment_user)
    blog = Blog.create!(:title => 'blog', :short_name => short_name, :creator => users(:quentin))
    post = create_blog_post(blog)
    comment = Comment.create(:post => post, :user => comment_user, :name => 'test name', :body => 'some comment')
    comment.stub!(:check_spam_answer).and_return(true)
    comment.save!
    return blog
  end

  def create_blog_post(blog)
    @post = Post.create!(:title => 'test', :body => 'test body', :publish_date => Date.today,
                         :user => users(:quentin), :tag_list => 'one two', :blog => blog)
  end

end


describe Blog do

  fixtures :users

  include BlogSpecHelper

  before(:each) do
    @blog = Blog.new
  end


  describe 'named scopes' do

    it "should have a published scope that returns blogs with in_draft flag set to false" do
      Blog.should have_named_scope(:published, { :order => "blogs.created_at DESC",
                                                 :conditions => { :in_draft => false }})
    end

    it "should have a recent scope that returns recent blogs ordered by date with limit" do
      Blog.should have_named_scope(:recent, { :limit => 20, :order => "blogs.created_at DESC" })
    end

    it "should have a comments_by scope that returns all blogs the user has commented in (through posts)" do
      blog = create_blog_post_comment('test-blog', users(:aaron))
      another_blog = create_blog_post_comment('test-blog-again', users(:quentin))
      Blog.with_comments_by(users(:aaron)).should eql([blog])
    end

  end


  describe 'being associated with' do

    it "should belong to a creator" do
      @blog.attributes = valid_blog_attributes.with(:created_by_id => 1)
      @blog.save!
      @blog.creator.should eql(users(:quentin))
    end

    it "should have users" do
      @blog.attributes = valid_blog_attributes
      create_blog_post(@blog)
      @blog.users.length.should eql(1)
    end

    it "should have posts" do
      @blog.attributes = valid_blog_attributes
      create_blog_post(@blog)
      @blog.posts.length.should eql(1)
    end

    it "should have comments" do
      @blog.attributes = valid_blog_attributes
      @post = create_blog_post(@blog)
      Comment.create!(:name => 'test', :body => 'test body', :post => @post,
                      :spam_question_id => 1, :spam_answer => 'cold')
      @blog.comments.length.should eql(1)
    end

    it "should have tags" do
      @blog.attributes = valid_blog_attributes
      @blog.save!
      @post = create_blog_post(@blog)
      @post.tags.length.should eql(2)
      @blog.tags.length.should eql(2)
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
      @blog.attributes = valid_blog_attributes.with(:short_name => '_+_+!h ello!')
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