class Blog < ActiveRecord::Base    
  
  validates_presence_of   :title, :short_name, :created_by_id 
  validates_format_of     :short_name, :with => RE_LOGIN_OK, :message => MSG_LOGIN_BAD, :allow_blank => true
  validates_length_of     :short_name, :maximum => 100, :allow_blank => true
  validates_uniqueness_of :short_name
  
  belongs_to :creator, :foreign_key => 'created_by_id', :class_name => 'User'
  has_many   :users, :through => :posts, :uniq => true
  has_many   :posts, :dependent => :destroy
  has_many   :comments, :through => :posts
  has_many   :published_comments, :through => :posts, :conditions => ['posts.in_draft = ?', false], :class_name => 'Comment'   
  acts_as_tagger
  
  named_scope :published, :conditions => {:in_draft => false}
  named_scope :recent, :limit => 20, :order => "blogs.created_at DESC" 
  
  
end
