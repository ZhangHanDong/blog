class RemoveTaggingsCountFromTags < ActiveRecord::Migration
  def self.up
    remove_column :tags, :taggings_count
  end

  def self.down
    add_column :tags, :taggings_count, :integer
    add_index  :tags, :taggings_count
  end
end
