class AddTimestamps < ActiveRecord::Migration
  def up
     change_table :entries do  |t|
     t.timestamps 
   end
   connection.execute %Q{
     alter table entries alter COLUMN updated_at type timestamp with time zone    ;
     alter table entries alter COLUMN created_at type timestamp with time zone    ;
     update entries set created_at=published where created_at is null;
     update entries set updated_at=updated where updated_at is null;
   }
  end
 
  def down
   remove_timestamps :entries
  end
end
