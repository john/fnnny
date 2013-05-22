class AddPostToFbToItem < ActiveRecord::Migration
  
  def change
    add_column :items, :post_to_fb, :boolean
  end
  
end
