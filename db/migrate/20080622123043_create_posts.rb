class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.string :title
      t.string :permalink
      t.datetime :publish_date
      t.text :summary
      t.text :body
      t.text :body_formatted
      t.boolean :in_draft, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :posts
  end
end
