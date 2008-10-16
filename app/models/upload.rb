class Upload < ActiveRecord::Base
  
  belongs_to :blog
  belongs_to :user
  
  has_attached_file :asset, :styles => { :thumb => ["64x64#", :jpg], :preview => ["200x", :jpg] },
                            :path => ":rails_root/public/images/u/assets/:class/:id/:style_:basename.:extension",
                            :url => "/images/u/assets/:class/:id/:style_:basename.:extension",
                            :default_url   => "/images/missing_:class.gif"
              
  validates_attachment_presence :asset             
  
  named_scope :recent, :limit => 20, :order => "uploads.created_at DESC"
  named_scope :by_user,  lambda { |*user| {:conditions =>  ["uploads.user_id = ?", user]}}
  
end
