class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.integer :user_id, :null => false
      t.string :name
      t.string :slug
      t.text :description
      t.string :url
      t.sring :sm_img_url
      t.string :md_img_url
      t.string :lg_img_url
      t.string :sq_img_url
      t.string :location
      t.float :latitude
      t.float :longitude
      t.integer :geo_quality

      t.timestamps
    end
    
    add_index :items, :slug, :unique => true
    
  end
end
