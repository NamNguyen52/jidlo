# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20141010214420) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "surveys", force: true do |t|
    t.string   "name"
    t.string   "location"
    t.string   "q1",           default: [], array: true
    t.string   "q2",           default: [], array: true
    t.string   "q3",           default: [], array: true
    t.string   "q4",           default: [], array: true
    t.integer  "people"
    t.string   "uniqueid"
    t.string   "restaurants",  default: [], array: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "survey2",      default: [], array: true
    t.string   "final_result", default: [], array: true
    t.string   "venue_one",    default: [], array: true
    t.string   "venue_two",    default: [], array: true
    t.string   "venue_three",  default: [], array: true
    t.string   "restaurant",   default: [], array: true
    t.string   "numbers"
  end

end
