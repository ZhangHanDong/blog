class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.integer :post_id
      t.integer :user_id
      t.string :name
      t.string :email
      t.string :website
      t.text :body
      
      t.timestamps
    end                     
    add_index :comments, [:post_id, :user_id]
  end

  def self.down
    drop_table :comments
  end
end