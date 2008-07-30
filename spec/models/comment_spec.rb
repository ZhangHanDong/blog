require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module CommentSpecHelper

  def valid_comment_attributes
    {
      :name => 'Jon Johnsson',
      :body => 'Phasellus pulvinar, nulla non *aliquam* eleifend, "tortor":http://google.com wisi scelerisque felis, in sollicitudin arcu ante lacinia leo.',
      :post => posts(:normal_post)
    }
  end

end

describe Comment do
      
  fixtures :comments, :posts

  include CommentSpecHelper

  before(:each) do
    @comment = Comment.new
  end          
          
  describe 'named scopes' do  
    
    it "should have a recent scope, and find recent comments (limited and ordered)" do
      1.upto(22) do
        Comment.create!(valid_comment_attributes)  
      end                                    
      @most_recent_comment = Comment.create!(valid_comment_attributes.with(:name => 'Very Recent Name', :created_at => Time.now+1.day))
      Comment.recent.length.should eql(20)        
      Comment.recent.first.name.should eql(@most_recent_comment.name)
    end          
         
  end     
  
  
  describe 'before save callbacks' do

    it "should have format format_website after_save (create)" # do
     #      @post.attributes = valid_post_attributes.with(:body => 'wejfn iewjnf wek *efwef* "some link":http://google.com wqdqw')
     #      @post.save!
     #      @post.body_formatted.should eql('<p>wejfn iewjnf wek <strong>efwef</strong> <a href="http://google.com">some link</a> wqdqw</p>')
     #    end
     #                                                              
    it "should have format format_website after_save (update)" # do
     #      @post.attributes = valid_post_attributes.with(:body => 'wejfn iewjnf wek *efwef* "some link":http://google.com wqdqw')
     #      @post.save!
     #      @post.update_attribute(:body, 'wejfn iewjnf wek *efwef*')
     #      @post.body_formatted.should eql('<p>wejfn iewjnf wek <strong>efwef</strong></p>')
     #    end                                                       

  end

   
  describe 'being associated with' do  
    
    it "should have a user" do
      @comment.attributes = valid_comment_attributes.with(:user_id => 1)
      @comment.save!
    end
    
    it "should have a post" do
      @comment.attributes = valid_comment_attributes         
      @comment.save!                                                                    
      @comment.post.should eql(posts(:normal_post))
    end
    
  end
        
  
  describe 'being validated' do  
    
    it "should be valid" do
      @comment.attributes = valid_comment_attributes
      @comment.should be_valid
    end

    it "should have an error on title" do
      @comment.attributes = valid_comment_attributes.except(:name)
      @comment.should have(1).error_on(:name)
    end

    it "should have an error on publish date" do
      @comment.attributes = valid_comment_attributes.except(:body)
      @comment.should have(1).error_on(:body)
    end

    it "should have an error on body" do
      @comment.attributes = valid_comment_attributes.except(:post)
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
