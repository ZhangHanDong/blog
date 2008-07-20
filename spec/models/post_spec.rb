require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module PostSpecHelper

  def valid_post_attributes
    {
      :title => 'Post Title',
      :publish_date => Date.today,
      :body => 'Phasellus pulvinar, nulla non *aliquam* eleifend, "tortor":http://google.com wisi scelerisque felis, in sollicitudin arcu ante lacinia leo.',
      :in_draft => false,
      :user_id => 1
    }
  end

end

describe Post do
      
  fixtures :posts

  include PostSpecHelper

  before(:each) do
    @post = Post.new
  end 
  
  
  describe 'helper methods' do           
    
    it "should return date range based on year and (optional) month, day params" do
      range = Post.get_date_range("2008", nil, nil)
      range.should eql({:start => Time.utc(2008, 1, 1), 
                        :end => Time.utc(2008, 1, 1).end_of_year, 
                        :descriptor => ' in 2008'})
                        
      range = Post.get_date_range("2007", "6", nil)
      range.should eql({:start => Time.utc(2007, 6, 1), 
                        :end => Time.utc(2007, 6, 1).end_of_month, 
                        :descriptor => ' in June 2007'})
      
      range = Post.get_date_range("2006", "2", "28")
      range.should eql({:start => Time.utc(2006, 2, 28), 
                        :end => Time.utc(2006, 2, 28).end_of_day, 
                        :descriptor => ' on Tuesday February 28, 2006'})
    end
    
  end         
             
        
  describe 'named scopes' do  
    
    it "should have a published scope, and find published posts" do
      @post.attributes = valid_post_attributes
      @post.save!
      @draft_post = Post.create!(valid_post_attributes.with(:in_draft => true))
      @draft_post.in_draft.should eql(true)                
      Post.find(:all).length.should eql(4)
      Post.published.should eql([@post, posts(:normal_post)]) 
    end
    
    it "should have a recent scope, and find recent posts (limited and ordered)" do
      1.upto(22) do
        Post.create!(valid_post_attributes)  
      end                                    
      @most_recent_post = Post.create!(valid_post_attributes.with(:title => 'Very Recent', :publish_date => (Time.now+1.day)))  
      Post.recent.length.should eql(20)        
      Post.recent.first.title.should eql(@most_recent_post.title)
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
        
  end
           
  
  describe 'being associated with' do  
    
    it "should have a user" do
      @post.attributes = valid_post_attributes.with(:user_id => 1)
      @post.save!
    end
    
    it "should have tags" do
      @post.attributes = valid_post_attributes.with(:tag_list => 'one "two tag" three')
      @post.save!                                                                    
      @post.tags.length.should eql(3)
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
