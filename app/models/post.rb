class Post < ActiveRecord::Base

  validates_presence_of :title, :publish_date, :body, :user_id
  validates_length_of   :summary, :maximum => 300, :allow_blank => true

  belongs_to :blog
  belongs_to :user
  has_many   :comments, :dependent => :destroy
  
  acts_as_taggable

  before_save :format_attributes

  named_scope :published, :conditions => { :in_draft => false }, :order => "posts.publish_date DESC"
  named_scope :recent, :limit => 20, :order => "posts.publish_date DESC"
  named_scope :in_range, lambda { |*dates| { :conditions => ["posts.publish_date >= ? AND posts.publish_date <= ?",
                                                             dates[0].to_s(:db),
                                                             dates[1].to_s(:db)] }}

  named_scope :by_user,  lambda { |*user| { :conditions => ["posts.user_id = ?", user] }}
  named_scope :with_tag, lambda { |*tag|  { :include => :taggings,
                                            :conditions => ["taggings.tag_id = ?", tag] }}


  def create_permalink
    # convert chars and shorten
    permalink = Iconv.new('ASCII//TRANSLIT', 'utf-8').iconv(self.title)
    permalink = permalink.downcase.strip.gsub(/[^-_\s[:alnum:]]/, '').squeeze(' ').tr(' ', '-')
    permalink = permalink[0, 120]

    # check existing posts in blog, for same day and same starting permalink
    if self.publish_date && self.blog
      date_range = Post.get_date_range(self.publish_date.year, 
                                       self.publish_date.month, 
                                       self.publish_date.day)
                                       
      posts = self.blog.posts.in_range(date_range[:start], date_range[:end]).find(:all, :conditions => ["permalink LIKE ? AND id != ?",
                                                                                                        "#{permalink}%", "#{self.id}"],
                                                                                                        :order => 'permalink DESC')
      unless posts.empty?
        postfix = (posts.first.permalink.split('-').last.to_i)+1
        permalink = "#{permalink}-#{postfix}"
      end
    end

    permalink
  end


  # hash options in url_for /blogs/:blog_id/:year/:month/:day/:permalink (mapped in routes)
  def permalink_url(options = {})
    return unless permalink
    { :only_path => false,
      :controller => "/posts",
      :action => "permalink",
      :blog_id => "#{self.blog.id}",
      :year => "#{self.publish_date.year}",
      :month => "#{self.publish_date.month}",
      :day => "#{self.publish_date.day}",
      :permalink => self.permalink }.merge(options)
  end


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
  def format_attributes
    self.permalink = self.create_permalink
    self.body_formatted = RedCloth.new(self.body).to_html
  end

end
