class AddAssetToUploads < ActiveRecord::Migration
  def self.up
    add_column :users, :asset_file_name, :string
    add_column :users, :asset_content_type, :string
    add_column :users, :asset_file_size, :integer
  end

  def self.down
    remove_column :users, :asset_file_name
    remove_column :users, :asset_content_type
    remove_column :users, :asset_file_size
  end
end
