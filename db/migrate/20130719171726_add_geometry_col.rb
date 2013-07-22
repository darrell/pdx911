class AddGeometryCol < ActiveRecord::Migration
  def up
   change_table :entries do  |t|
     t.point :geom, :srid => 4326 
     t.index :geom, :spatial => true
   end
   connection.execute %Q{
CREATE OR REPLACE FUNCTION latlong_to_geom() returns trigger as $$
BEGIN
  NEW.geom := ST_SetSRID(ST_MakePoint(NEW.longitude, NEW.latitude),4326);
  RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER latlong_to_geom
   BEFORE INSERT OR UPDATE ON "entries"
   FOR EACH ROW EXECUTE PROCEDURE latlong_to_geom();
 
   }
  end

  def down
  end
end
