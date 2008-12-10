# Patches to acts_as_taggable_redux plugin for belonging to blog

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
              if self.methods.include?('cached_tag_list') && self.tags
                self.update_attribute(:cached_tag_list, tags.collect { |tag| tag.name.include?(" ") ? %("#{tag.name}") : tag.name }.join(" "))
              end
            end
          end
        end
      end
    end
  end
end

module ActsAsTaggableHelper
  
  # Generate a tag cloud of the top 100 tags by usage, uses the proposed hTagcloud microformat.
  def blog_tag_cloud(blog, tags)
    # TODO: add option to specify which classes you want and overide this if you want?
    classes = %w(popular v-popular vv-popular vvv-popular vvvv-popular)
    
    max, min = 0, 0
    
    # get tag counts and cache in array
    counts = []
    tags.each do |tag|
      counts[tag.id] = tag.blog_taggings_count(blog)
    end
    
    tags.each do |tag|
      max = counts[tag.id] if counts[tag.id] > max
      min = counts[tag.id] if counts[tag.id] < min
    end
    
    divisor = ((max - min) / classes.size) + 1
    
    html =    %(<div class="hTagcloud">\n)
    html <<   %(  <ul class="popularity">\n)
    tags.each do |tag|
      html << %(    <li>)
      html << link_to(tag.name, blog_tag_name_url(blog, tag), :class => classes[(counts[tag.id] - min) / divisor]) 
      html << %(</li> \n)
    end
    html <<   %(  </ul>\n)
    html <<   %(</div>\n)
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
  
  def blog_taggings_count(blog)
    taggings.count(:conditions => {:blog_id => blog.id})
  end
  
end

# vendor/plugins/acts_as_taggable_redux/lib/tagging.rb
# new association with blog
class Tagging < ActiveRecord::Base
  belongs_to :blog
end