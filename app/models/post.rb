class Post < ActiveRecord::Base  

  validates_presence_of :title, :publish_date, :body, :user_id
  validates_length_of :summary, :maximum => 300, :allow_blank => true
  belongs_to :user           
  has_many   :comments, :order => "created_at DESC"
  
  before_save :format_body
                                                              
  named_scope :published, :conditions => {:in_draft => false}, :order => "publish_date DESC"    
  acts_as_taggable
  
  
  private
  def format_body
    self.body_formatted = RedCloth.new(self.body).to_html
  end
  
end
