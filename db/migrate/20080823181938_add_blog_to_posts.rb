class AddBlogToPosts < ActiveRecord::Migration
  def self.up         
    add_column :posts, :blog_id, :integer
    add_index :posts, :blog_id
  end

  def self.down
    remove_column :posts, :blog_id
  end
end
