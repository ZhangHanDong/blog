class Upload < ActiveRecord::Base
  
  belongs_to :blog
  belongs_to :user
  
  has_attached_file :asset, :styles => { :thumb => ["60x60>", :gif] },
                            :path => ":rails_root/public/images/u/:class/:id/:style_:basename.:extension",
                            :url => "/images/u/:class/:id/:style_:basename.:extension",
                            :default_url   => "/images/missing_:class.gif"
                           
  validates_attachment_content_type :asset, :content_type => ["image/png", "image/jpeg", "image/jpg", "image/gif"]
  
end
