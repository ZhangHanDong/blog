class AddCachedTagListToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :cached_tag_list, :text
  end

  def self.down
    remove_column :posts, :cached_tag_list
  end
end
