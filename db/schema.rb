# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20130723163544) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "entries", force: true do |t|
    t.string   "entry_id"
    t.string   "call_type"
    t.string   "address"
    t.string   "agency"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "updated"
    t.datetime "published"
    t.spatial  "geom",       limit: {:srid=>4326, :type=>"point"}
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "entries", ["entry_id"], :name => "index_entries_on_entry_id", :unique => true
  add_index "entries", ["geom"], :name => "index_entries_on_geom", :spatial => true

end
