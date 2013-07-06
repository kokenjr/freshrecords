class AddArtistIdAndRemoveArtistFromRecords < ActiveRecord::Migration
  def change
    add_column :records, :artist_id, :integer
    remove_column :records, :artist
  end
end
