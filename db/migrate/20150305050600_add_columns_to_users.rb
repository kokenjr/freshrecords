class AddColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :artist_notification, :boolean, default: true
    add_column :users, :wishlist_notification, :boolean, default: true
  end
end
