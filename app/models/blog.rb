class Blog < ActiveRecord::Base

  validates_presence_of   :title, :short_name, :created_by_id
  validates_format_of     :short_name, :with => RE_ALPHANUM_OK, :message => MSG_ALPHANUM_BAD,
                          :allow_blank => true
  validates_length_of     :short_name, :maximum => 100, :allow_blank => true
  validates_uniqueness_of :short_name

  belongs_to :creator,  :class_name => 'User', :foreign_key => 'created_by_id'
  has_many   :users,    :through => :posts, :uniq => true
  has_many   :posts,    :dependent => :destroy
  has_many   :comments, :through => :posts
  has_many   :uploads,  :order => "uploads.created_at DESC"

  acts_as_tagger

  named_scope :published, :conditions => { :in_draft => false }, :order => 'blogs.created_at DESC'
  named_scope :recent,    :limit => 20, :order => "blogs.created_at DESC"
  named_scope :with_comments_by, lambda { |*user| {:conditions => ['comments.user_id = ? ', user],
                                                   :include => { :posts => :comments }}}
end
