class Comment < ActiveRecord::Base
  
  validates_presence_of :name, :body, :post_id                                                                                                                           
  validates_format_of   :email,   :with => RE_EMAIL_OK, :message => MSG_EMAIL_BAD, :allow_blank => true
  validates_length_of   :email,   :within => 6..100, :allow_blank => true   #r@a.wk
  
  belongs_to :post
  belongs_to :user 
  
  before_save :format_website
  
  named_scope :recent, :limit => 20, :order => "created_at DESC"
  
  private
  def format_website
    self.website = "http://#{self.website}" unless self.website =~ /^(http|https):\/\// 
  end

end
