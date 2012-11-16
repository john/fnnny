class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :user_id,       :null => false
      t.string :fb_id,          :null => false, :unique => true
      t.string :from_id,        :null => false
      t.string :object_id,        :null => false
      t.string :post_id,        :null => false
      t.text :message,          :null => false
      t.string :fb_create_time, :null => false
      t.integer :like_count,    :null => false, :default => 0
      t.integer :user_likes,    :null => false, :default => 0
      t.integer :commentable_id,    :null => false
      t.string :commentable_type,    :null => false

      t.timestamps
    end
  end
end
