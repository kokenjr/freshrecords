class ChangeUriTypesInRecord < ActiveRecord::Migration
  def up
    change_column :records, :image_url, :text
    change_column :records, :prod_url, :text
    change_column :records, :spotify_uri, :text
    change_column :records, :discogs_uri, :text
  end

  def down
    change_column :records, :image_url, :string
    change_column :records, :prod_url, :string
    change_column :records, :spotify_uri, :string
    change_column :records, :discogs_uri, :string
  end
end
