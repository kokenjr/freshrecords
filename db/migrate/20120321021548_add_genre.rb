class AddGenre < ActiveRecord::Migration
  def change
    add_column(:records, :genre, :string) 
  end

  #def down
  #end
end
