class CreateArtistsUsers < ActiveRecord::Migration
  def change
    create_table :artists_users do |t|
      t.integer :artist_id
      t.integer :user_id

      t.timestamps
    end
    add_index :artists_users, :artist_id
    add_index :artists_users, :user_id
  end
end
