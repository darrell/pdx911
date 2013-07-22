class CreateEntries < ActiveRecord::Migration
  def up
  create_table(:entries) do |t|
     t.string :entry_id,  :length => 30
     t.index :entry_id, :unique => true
     t.string :call_type
     t.string :address
     t.string :agency
     t.float :latitude
     t.float :longitude
     t.timestamp :updated
     t.timestamp :published
    end
  end

  def down
    drop_table :entries
  end
end
