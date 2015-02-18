class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.string :asin
      t.string :name
      t.string :artist
      t.decimal :price
      t.date :release_date
      t.string :image_url
      t.string :prod_url
      t.string :record_label

      t.timestamps
    end
  end
end
