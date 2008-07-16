class Comment < ActiveRecord::Base
  
  validates_presence_of :name, :body, :post_id                                                                                                                           
  validates_format_of   :email,   :with => RE_EMAIL_OK, :message => MSG_EMAIL_BAD, :allow_blank => true
  validates_length_of   :email,   :within => 6..100, :allow_blank => true   #r@a.wk
  validates_format_of   :website, :with => /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/ix, :allow_blank => true
  
  belongs_to :post
  belongs_to :user
  
  named_scope :recent, :limit => 20, :order => "created_at DESC"
  
end