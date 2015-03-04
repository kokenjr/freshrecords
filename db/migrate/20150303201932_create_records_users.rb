class CreateRecordsUsers < ActiveRecord::Migration
  def change
    create_table :records_users do |t|
      t.integer :user_id
      t.integer :record_id

      t.timestamps
    end
    add_index :records_users, :user_id
    add_index :records_users, :record_id
  end
end
