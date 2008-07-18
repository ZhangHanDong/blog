class Post < ActiveRecord::Base

  validates_presence_of :title, :publish_date, :body, :user_id
  validates_length_of :summary, :maximum => 300, :allow_blank => true

  belongs_to :user
  has_many   :comments

  before_save :format_body

  named_scope :published, :conditions => {:in_draft => false}, :order => "publish_date DESC"
  named_scope :recent, :limit => 20, :order => "publish_date DESC"
  named_scope :in_range, lambda { |*dates| {:conditions =>  ["publish_date >= ? AND publish_date <= ?", dates[0].to_s(:db), dates[1].to_s(:db)]} }

  acts_as_taggable





  def self.get_date_range(year, month = 1, day = 1)
    start_date = end_date = Time.utc(year, month, day)
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

end
