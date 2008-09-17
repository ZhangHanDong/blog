# Patches to acts_as_taggable_redux plugin for belonging to blog and admin path helper

# vendor/plugins/acts_as_taggable_redux/lib/acts_as_taggable.rb
# allowing tag to be created with blog reference
module ActiveRecord
  module Acts #:nodoc:
    module Taggable #:nodoc:
      module InstanceMethods

        def blog_id=(new_blog_id)
          @new_blog_id = new_blog_id
          super(new_blog_id)
        end

        def update_tags
          if @new_tag_list
            Tag.transaction do
              unless @new_user_id
                taggings.destroy_all
              else
                taggings.find(:all, :conditions => "user_id = #{@new_user_id}").each do |tagging|
                  tagging.destroy
                end
              end

              Tag.parse(@new_tag_list).each do |name|
                if self.blog
                  Tag.find_or_create_by_name(name).tag(self, @new_user_id, self.blog_id)
                else
                  Tag.find_or_create_by_name(name).tag(self, @new_user_id)
                end
              end

              tags.reset
              taggings.reset
              @new_tag_list = nil
            end
          end
        end
      end
    end
  end
end


# vendor/plugins/acts_as_taggable_redux/lib/acts_as_taggable_helper.rb
# helper for linking
module ActsAsTaggableHelper

  def link_to_admin_tag(tag)
    link_to(tag.name, admin_tag_url(tag), :rel => 'tag')
  end
end

# vendor/plugins/acts_as_taggable_redux/lib/tag.rb
# new named scopes and association with blogs, also creating a tagging referencing a blog id
class Tag < ActiveRecord::Base
  has_many :blogs, :through => :taggings, :uniq => true

  named_scope :by_user,  lambda { |*user| {:conditions =>  ["taggings.user_id = ?", user], :include => :taggings}}
  named_scope :recent, :limit => 20, :order => "tags.id DESC"

  # Tag a taggable with this tag, optionally add user to add owner to tagging
  def tag(taggable, user_id = nil, blog_id = nil)
    taggings.create :taggable => taggable, :user_id => user_id, :blog_id => blog_id
    taggings.reset
    @tagged = nil
  end
end

# vendor/plugins/acts_as_taggable_redux/lib/tagging.rb
# new association with blog
class Tagging < ActiveRecord::Base
  belongs_to :blog
end