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

ActiveRecord::Schema.define(version: 20140905065522) do

  create_table "assignments", force: true do |t|
    t.integer  "timeslot_id"
    t.integer  "boat_id"
    t.integer  "booked_timeslot_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "assignments", ["timeslot_id", "boat_id"], name: "index_assignments_on_timeslot_id_and_boat_id", unique: true

  create_table "boats", force: true do |t|
    t.integer  "capacity"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bookings", force: true do |t|
    t.integer  "timeslot_id"
    t.integer  "size"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "timeslots", force: true do |t|
    t.integer  "start_time"
    t.integer  "duration"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
