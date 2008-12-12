require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module PostSpecHelper

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

  def create_posts_over_days(number_of_days, starting_from_date = Time.now,  attributes = Hash.new)
    1.upto(number_of_days) do
      Post.create!(valid_post_attributes.with(attributes.merge(:publish_date => starting_from_date)))
      starting_from_date = starting_from_date + 1.day
    end
  end

end

describe Post do

  fixtures  :users, :posts

  include PostSpecHelper

  before(:each) do
    @post = Post.new
  end


  describe 'helper methods' do

    it "should return date range based on year" do
      range = Post.get_date_range("2008", nil, nil)
      range[:start].to_date.should eql(Time.utc("2008", "1", "1").to_date)
      range[:end].to_date.should eql(Time.utc("2008", "1", "1").end_of_year.to_date)
      range[:descriptor].should eql(' in 2008')
    end

    it "should return date range based on year and (optional) month" do
      range = Post.get_date_range("2007", "6", nil)
      range[:start].to_date.should eql(Time.utc("2007", "6", "1").to_date)
      range[:end].to_date.should eql(Time.utc("2007", "6", "1").end_of_month.to_date)
      range[:descriptor].should eql(' in June 2007')
    end

    it "should return date range based on year and (optional) month, day params" do
      range = Post.get_date_range("2006", "2", "28")
      range[:start].to_date.should eql(Time.utc("2006", "2", "28").to_date)
      range[:end].to_date.should eql(Time.utc("2006", "2", "28").end_of_day.to_date)
      range[:descriptor].should eql(' on Tuesday February 28, 2006')
    end

    it "should return current day if range params are invalid" do
      range = Post.get_date_range("2006", "13", "700")
      range[:start].to_date.should eql(Time.now.to_date)
      range[:end].to_date.should eql(Time.now.end_of_day.to_date)
    end
  end

  describe "permalink creation" do
      
    it "should not change permalink with multiple saves" do
      blog = Blog.create!(:title => 'blog', :short_name => 'blog', :creator => users(:quentin))
      post_1 = Post.create!(valid_post_attributes.with(:title => 'another title', 
                                                       :publish_date => Date.today, :blog => blog))
      post_1.permalink.should eql('another-title')
      blog.save!
      post_1.save!
      post_1.permalink.should eql('another-title')
      post_1.update_attribute(:title, 'another title')
      post_1.permalink.should eql('another-title')
    end

    it "should give different permalinks for posts with the same title on same day" do
      blog = Blog.create!(:title => 'blog', :short_name => 'blog', :creator => users(:quentin))
      post_1 = Post.create!(valid_post_attributes.with(:title => 'another title', 
                                                       :publish_date => Date.today, :blog => blog))
      post_1.permalink.should eql('another-title')
      blog.save!
      blog.posts.reload
      post_2 = Post.new(valid_post_attributes.with(:title => 'another title', 
                                                   :blog => blog, :publish_date => Date.today))
      post_2.save!
      post_2.permalink.should eql('another-title-1')
      blog.posts.reload
      post_3 = Post.new(valid_post_attributes.with(:title => 'another title', 
                                                   :blog => blog, :publish_date => Date.today))
      post_3.save!
      post_3.permalink.should eql('another-title-2')
    end
    
    it "should allow two posts to have same permalink on different days" do
      blog = Blog.create!(:title => 'blog', :short_name => 'blog', :creator => users(:quentin))
      post_1 = Post.create!(valid_post_attributes.with(:title => 'another title', 
                                                       :publish_date => Date.today, :blog => blog))
      post_1.permalink.should eql('another-title')
      blog.save!
      blog.posts.reload
      post_2 = Post.new(valid_post_attributes.with(:title => 'another title', 
                                                   :blog => blog, :publish_date => Date.today+1))
      post_2.save!
      post_2.permalink.should eql('another-title')
    end

    it "should give different permalinks for posts with the same title on same day \ 
        (on update and taking permalink name from last permalink added)" do
      blog = Blog.create!(:title => 'blog', :short_name => 'blog', :creator => users(:quentin))
      post_1 = Post.create!(valid_post_attributes.with(:title => 'another title', 
                                                       :publish_date => Date.today, :blog => blog))
      blog.save!
      blog.posts.reload
      post_2 = Post.new(valid_post_attributes.with(:title => 'something else', 
                                                   :blog => blog, :publish_date => Date.today))
      post_2.save!
      post_2.permalink.should eql('something-else')
      blog.posts.reload
      post_3 = Post.new(valid_post_attributes.with(:title => 'another title', 
                                                   :blog => blog, :publish_date => Date.today))
      post_3.save!
      blog.posts.reload
      post_2.update_attribute(:title, 'another title')
      post_2.permalink.should eql('another-title-2')
    end

    it "should shorten permalink string for a long title" do
      @post = Post.create!(valid_post_attributes.with(:title => '123456789Z 123456789Z 123456789Z 123456789Z 123456789Z 123456789Z 123456789Z 123456789Z 123456789Z 123456789Z 123456789Z 123456789Z too long here'))
      @post.permalink.should eql('123456789z-123456789z-123456789z-123456789z-123456789z-123456789z-123456789z-123456789z-123456789z-123456789z-123456789z')
    end

  end


  describe 'named scopes' do

    it "should have a published scope, and find published posts" do
      @post.attributes = valid_post_attributes
      @post.save!
      @draft_post = Post.create!(valid_post_attributes.with(:in_draft => true))
      @draft_post.in_draft.should eql(true)
      Post.find(:all).length.should eql(4)
      Post.published.length.should eql(2)
    end

    it "should have a recent scope, and find recent posts (limited and ordered)" do
      create_posts_over_days(22, Time.mktime(2007,3,1))
      @most_recent_post = Post.create!(valid_post_attributes.with(:title => 'Very Recent', 
                                                                  :publish_date => Time.now+1.day))
      Post.recent.length.should eql(20)
      Post.recent.first.title.should eql(@most_recent_post.title)
    end

    it "should have an in range scope (date range) over mar-apr" do
      create_posts_over_days(10, Time.mktime(2007,3,25))
      start_date = Time.mktime(2007,3,30)
      end_date = Time.mktime(2007,4,2)
      Post.in_range(start_date, end_date).length.should eql(3)
    end

    it "should have an in range scope (date range) over a few days" do
      create_posts_over_days(3, Time.mktime(2007,3,25))
      create_posts_over_days(2, Time.mktime(2007,3,25))
      start_date = Time.mktime(2007,3,25)
      end_date = Time.mktime(2007,3,26)
      Post.in_range(start_date, end_date).length.should eql(4)
    end


    it "should have a recent scope that returns up to 20 posts ordered by publish_date DESC" do
      Post.should have_named_scope(:recent, {:limit=>20, :order=>"posts.publish_date DESC"})
    end

    it "should have a by_user scope that returns posts created by a user" do
      Post.should have_named_scope(:by_user, {:conditions=>["posts.user_id = ?", []]})
    end

    it "should have a published scope that returns posts with in_draft set to false \ 
        and ordered by publish_date DESC" do
      Post.should have_named_scope(:published, {:conditions=>{:in_draft=>false}, 
                                   :order=>"posts.publish_date DESC"})
    end

    it "should have a with_tag scope that returns posts tagged with a matching tag" do
      Post.should have_named_scope(:with_tag, {:include=>:taggings, 
                                   :conditions=>["taggings.tag_id = ?", []]})
    end

  end


  describe 'before save callbacks' do

    it "should have format body_formatted after_save (create)" do
      @post.attributes = valid_post_attributes.with(:body => 'wejfn iewjnf wek *efwef* "some link":http://google.com wqdqw')
      @post.save!
      @post.body_formatted.should eql('<p>wejfn iewjnf wek <strong>efwef</strong> <a href="http://google.com">some link</a> wqdqw</p>')
    end

    it "should have format body_formatted after_save (update)" do
      @post.attributes = valid_post_attributes.with(:body => 'wejfn iewjnf wek *efwef* "some link":http://google.com wqdqw')
      @post.save!
      @post.update_attribute(:body, 'wejfn iewjnf wek *efwef*')
      @post.body_formatted.should eql('<p>wejfn iewjnf wek <strong>efwef</strong></p>')
    end

    it "should create and set permalink using title (create)" do
      @post.attributes = valid_post_attributes.with(:title => 'check one two three four (â Â, ê Ê, î Î, ô Ô, û Û, ŵ) http://google.com')
      @post.save!
      @post.permalink.should eql('check-one-two-three-four-a-a-e-e-i-i-o-o-u-u-w-httpgooglecom')
    end

    it "should update and set permalink using title (update)" do
      @post.attributes = valid_post_attributes.with(:title => 'check one two three four (â Â)')
      @post.save!
      @post.update_attribute(:title, 'wejfn iewjnf wek *efwef* //`~`&@@@ |! kebf le')
      @post.permalink.should eql('wejfn-iewjnf-wek-efwef-kebf-le')
    end


  end


  describe 'being associated with' do

    it "should have a user" do
      @post.attributes = valid_post_attributes
      @post.save!
      @post.user.should eql(users(:quentin))
    end

    it "should have tags" do
      @post.attributes = valid_post_attributes.with(:tag_list => 'one "two tag" three')
      @post.save!
      @post.tags.length.should eql(3)
    end

    it "should have comments" do
      @post.attributes = valid_post_attributes
      @post.save!
      @post.comments << Comment.new(:name => 'test', :body => 'test body')
      @post.comments.length.should eql(1)
    end

    it "should belong to a blog" do
      @blog = Blog.create!(:title => 'test', :short_name => 'test', :created_by_id => 1)
      @post.attributes = valid_post_attributes.with(:blog => @blog)
      @post.save!
      @post.blog.should eql(@blog)
    end

  end


  describe 'being validated' do

    it "should be valid" do
      @post.attributes = valid_post_attributes
      @post.should be_valid
    end

    it "should have an error on title" do
      @post.attributes = valid_post_attributes.except(:title)
      @post.should have(1).error_on(:title)
    end

    it "should have an error on publish date" do
      @post.attributes = valid_post_attributes.except(:publish_date)
      @post.should have(1).error_on(:publish_date)
    end

    it "should have an error on body" do
      @post.attributes = valid_post_attributes.except(:body)
      @post.should have(1).error_on(:body)
    end

    it "should have an error on user" do
      @post.attributes = valid_post_attributes.except(:user_id)
      @post.should have(1).error_on(:user_id)
    end

    it "should have an error on summary length" do
      @post.attributes = valid_post_attributes.with(:summary => 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Morbi commodo, ipsum sed pharetra gravida, orci magna rhoncus neque, id pulvinar odio lorem non turpis. Nullam sit amet enim. Suspendisse id velit vitae ligula volutpat condimentum. Aliquam erat volutpat. Sed quis velit. Nulla facilisi. Nulla libero. Vivamus pharetra posuere sapien. Nam consectetuer. Sed aliquam, nunc eget euismod ullamcorper, lectus nunc ullamcorper orci, fermentum bibendum enim nibh eget ipsum. Donec porttitor ligula eu dolor. Maecenas vitae nulla consequat libero cursus venenatis. Nam magna enim, accumsan eu, blandit sed, blandit a, eros.Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Morbi commodo, ipsum sed pharetra gravida, orci magna rhoncus neque, id pulvinar odio lorem non turpis. Nullam sit amet enim. Suspendisse id velit vitae ligula volutpat condimentum. Aliquam erat volutpat. Sed quis velit. Nulla facilisi. Nulla libero. Vivamus pharetra posuere sapien. Nam consectetuer. Sed aliquam, nunc eget euismod ullamcorper, lectus nunc ullamcorper orci, fermentum bibendum enim nibh eget ipsum. Donec porttitor ligula eu dolor. Maecenas vitae nulla consequat libero cursus venenatis. Nam magna enim, accumsan eu, blandit sed, blandit a, eros.')
      @post.should have(1).error_on(:summary)
    end
  end

end
