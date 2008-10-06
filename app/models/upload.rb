class Upload < ActiveRecord::Base
  
  belongs_to :blog
  belongs_to :user
  
  has_attached_file :asset, :styles => { :thumb => ["32x32>", :jpg], :preview => ["200x", :jpg] },
                            :path => ":rails_root/public/images/u/assets/:class/:id/:style_:basename.:extension",
                            :url => "/images/u/assets/:class/:id/:style_:basename.:extension",
                            :default_url   => "/images/missing_:class.gif"
              
  validates_attachment_presence :asset             
  validates_attachment_content_type :asset, :content_type => ["image/png", "image/jpeg", "image/jpg", "image/gif"]
  
  named_scope :recent, :limit => 20, :order => "uploads.created_at DESC"
  
end
