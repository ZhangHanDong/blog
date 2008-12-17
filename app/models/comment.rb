class Comment < ActiveRecord::Base

  validates_presence_of :name, :body, :post_id
  validates_format_of   :email, :with => RE_EMAIL_OK, :message => MSG_EMAIL_BAD,
                        :allow_blank => true
  validates_length_of   :email, :within => 6..100, :allow_blank => true #r@a.wk

  belongs_to :post
  belongs_to :user

  before_save :format_website

  named_scope :recent, :limit => 20, :order => "comments.created_at DESC"
  named_scope :by_user, lambda { |*user| { :conditions =>  ["comments.user_id = ?", user] }}
  named_scope :published, :include => :post, :conditions => ["posts.in_draft = ?", false]

  attr_accessor :spam_answer, :spam_question_id

  def validate
    errors.add_to_base "You're answer is incorrect, try again" unless check_spam_answer
  end

  def self.random_spam_question
    APP_CONFIG['spam_questions'][rand(APP_CONFIG['spam_questions'].size)]
  end


  private
  def format_website
    self.website = "http://#{self.website}" unless self.website =~ /^(http|https):\/\//
  end

  def check_spam_answer
    question = APP_CONFIG['spam_questions'].select{ |q| q['id'] == self.spam_question_id.to_i }.first
    if question
      return self.spam_answer.strip.downcase =~ /#{question['answer'].downcase}/
    else
      false
    end
  end

end
