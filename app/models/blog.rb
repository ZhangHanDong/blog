class Blog < ActiveRecord::Base    
  
  validates_presence_of :title, :short_name, :created_by_id 
  validates_format_of :short_name, :with => RE_LOGIN_OK, :message => MSG_LOGIN_BAD, :allow_blank => true
  validates_length_of :short_name, :maximum => 100, :allow_blank => true
  validates_uniqueness_of :short_name
  
  belongs_to :creator, :foreign_key => 'created_by_id', :class_name => 'User'
  
  named_scope :published, :conditions => {:in_draft => false}
  
end
