class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.integer :user_id
      t.string :request_id
      t.string :to_id
      t.string :state

      t.timestamps
    end
  end
end
