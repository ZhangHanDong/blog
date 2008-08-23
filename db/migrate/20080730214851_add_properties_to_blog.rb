class AddPropertiesToBlog < ActiveRecord::Migration
  def self.up
    add_column :blogs, :short_name, :string
    add_column :blogs, :in_draft, :boolean
    add_column :blogs, :created_by_id, :integer
    add_index  :blogs, :created_by_id
  end

  def self.down
    remove_column :blogs, :short_name
    remove_column :blogs, :in_draft
    remove_column :blogs, :created_by_id
  end
end
