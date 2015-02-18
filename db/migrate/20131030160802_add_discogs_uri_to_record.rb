class AddDiscogsUriToRecord < ActiveRecord::Migration
  def change
    add_column :records, :discogs_uri, :string
  end
end
