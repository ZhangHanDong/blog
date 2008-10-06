class CreateUploads < ActiveRecord::Migration
  def self.up
    create_table :uploads do |t|
      t.integer :blog_id
      t.integer :user_id
      t.string  :asset_file_name
      t.string  :asset_content_type
      t.integer :asset_file_size
      
      t.timestamps
    end
  end

  def self.down
    drop_table :uploads
  end
end
