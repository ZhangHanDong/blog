class Upload < ActiveRecord::Base
  
  validates_presence_of :user_id
  
  belongs_to :blog
  belongs_to :user
  
  has_attached_file :asset, :styles => { :thumb => ["64x64#", :jpg], :preview => ["200x", :jpg] },
                            :path => ":rails_root/public/images/u/assets/:class/:id/:style_:basename.:extension",
                            :url => "/images/u/assets/:class/:id/:style_:basename.:extension",
                            :default_url   => "/images/missing_:class.gif"
              
  validates_attachment_presence :asset             
  validates_attachment_content_type :asset, :content_type => ['image/jpg', 
                                                              'image/jpeg', 
                                                              'image/gif', 
                                                              'image/png',
                                                              'text/html',
                                                              'text/xml',
                                                              'text/plain',
                                                              'video/quicktime',
                                                              'video/avi',
                                                              'video/msvideo',
                                                              'video/x-msvideo',
                                                              'video/mpeg',
                                                              'video/mp4',
                                                              'audio/basic',
                                                              'audio/x-au',
                                                              'audio/mpeg',
                                                              'audio/x-aiff',
                                                              'audio/x-mpeg-3',
                                                              'application/powerpoint',
                                                              'application/excel',
                                                              'application/msword',
                                                              'application/pdf',
                                                              'application/x-shockwave-flash',
                                                              'application/xml',
                                                              'application/vnd.google-earth.kml+xml kml',
                                                              'application/vnd.google-earth.kmz kmz'
                                                              ]
  
  named_scope :recent, :limit => 20, :order => "uploads.created_at DESC"
  named_scope :by_user,  lambda { |*user| {:conditions =>  ["uploads.user_id = ?", user]}}
  
end
