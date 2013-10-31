class AddSpotifyUriToRecords < ActiveRecord::Migration
  def change
    add_column :records, :spotify_uri, :string
  end
end
