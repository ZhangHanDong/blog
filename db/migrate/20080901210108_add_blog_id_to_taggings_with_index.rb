class AddBlogIdToTaggingsWithIndex < ActiveRecord::Migration
  def self.up    
    add_column :taggings, :blog_id, :integer
    add_index :taggings, :blog_id
  end

  def self.down        
    remove_column :taggings, :blog_id      
  end
end
