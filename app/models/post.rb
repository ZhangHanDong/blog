class Post < ActiveRecord::Base

  validates_presence_of :title, :publish_date, :body, :user_id
  validates_length_of   :summary, :maximum => 300, :allow_blank => true

  belongs_to :blog
  belongs_to :user
  has_many   :comments, :dependent => :destroy
  acts_as_taggable
  
  before_save :format_body    
  before_save :format_permalink

  named_scope :published, :conditions => {:in_draft => false}, :order => "posts.publish_date DESC"
  named_scope :recent, :limit => 20, :order => "posts.publish_date DESC"
  named_scope :in_range, lambda { |*dates| {:conditions =>  ["posts.publish_date >= ? AND posts.publish_date <= ?", dates[0].to_s(:db), dates[1].to_s(:db)]}}
  named_scope :by_user,  lambda { |*user| {:conditions =>  ["posts.user_id = ?", user]}}
  named_scope :with_tag, lambda { |*tag| {:include => :taggings, :conditions =>  ["taggings.tag_id = ?", tag]}}


  def self.get_date_range(year, month = 1, day = 1)
    start_date = end_date = Time.utc(year, month, day) rescue Time.now
    if year && month && day
      descriptor = " on #{start_date.strftime("%A %B #{start_date.day}, %Y")}"
      end_date = start_date.end_of_day 
    elsif month && year && !day
      descriptor = " in #{start_date.strftime("%B %Y")}"      
      end_date = start_date.end_of_month
    elsif year && !month && !day
      descriptor = " in #{start_date.strftime("%Y")}"      
      end_date = start_date.end_of_year
    end
    {:start => start_date, :end => end_date, :descriptor => descriptor}
  end


  private
  def format_body
    self.body_formatted = RedCloth.new(self.body).to_html
  end
  
  def format_permalink
    self.permalink = Post.create_permalink(self.title)
  end
  
  def self.create_permalink(text, seperator='-', max_length = 255)
    # convert chars
    t = Iconv.new('ASCII//TRANSLIT', 'utf-8').iconv(text)
    t = t.downcase.strip.gsub(/[^-_\s[:alnum:]]/, '').squeeze(' ').tr(' ', seperator)
    t = (t.blank?) ? seperator : t
    # limit length
    t = t[0, max_length]
  end

end
