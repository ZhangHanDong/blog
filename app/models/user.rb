require 'digest/sha1'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken

  validates_presence_of     :login
  validates_length_of       :login,    :within => 3..40
  validates_uniqueness_of   :login,    :case_sensitive => false
  validates_format_of       :login,    :with => RE_LOGIN_OK, :message => MSG_LOGIN_BAD

  validates_format_of       :name,     :with => RE_NAME_OK,  :message => MSG_NAME_BAD, :allow_nil => true
  validates_length_of       :name,     :maximum => 100

  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email,    :case_sensitive => false
  validates_format_of       :email,    :with => RE_EMAIL_OK, :message => MSG_EMAIL_BAD

  # anything else you want user to change should be added here
  attr_accessible :login, :email, :name, :password, :password_confirmation, :photo

  has_many :created_blogs, :class_name => 'Blog', :foreign_key => 'created_by_id'
  has_many :posts, :order => "created_at DESC"     
  has_many :taggings 
  has_many :comments, :order => "created_at DESC"     
  has_many :tags, :through => :taggings
  
  has_attached_file :photo, :styles => { :tiny => ["30x30>", :gif], :thumb => ["60x60>", :gif] }, 
                            :path => ":rails_root/public/images/u/:class/:id/:style_:basename.:extension",
                            :url => "/images/u/:class/:id/:style_:basename.:extension",
                            :default_url   => "/images/missing_:class.gif"
                            
  validates_attachment_content_type :photo, :content_type => ["image/png", "image/jpeg", "image/jpg", "image/gif"], 
                                            :message => "Only png, jpg, and gif images are allowed for your photo"
  

  # authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
     # need to get the salt
    if login =~ /\A[\w\.%\+\-]+@(?:[A-Z0-9\-]+\.)+(?:[A-Z]{2}|com|org|net|gov|mil|biz|info|mobi|name|aero|jobs|museum)\z/i    
      u = find_by_email(login)
    else                      
      u = find_by_login(login)
    end
    u && u.authenticated?(password) ? u : nil
  end

end
