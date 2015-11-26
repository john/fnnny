class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.integer :user_id, :null => false
      t.string :name, :null => false
      t.text :description
      t.string :url
      t.string :image
      t.string :original_image_url
      t.string :location
      t.float :latitude
      t.float :longitude
      t.integer :geo_quality
      t.integer :comments_count, :null => false, :default => 0

      t.timestamps
    end
    
  end
end
