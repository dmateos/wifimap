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

ActiveRecord::Schema.define(version: 20150106124140) do

  create_table "access_points", force: :cascade do |t|
    t.string   "ssid",         limit: 255
    t.string   "mac",          limit: 255, null: false
    t.string   "freq",         limit: 255
    t.string   "capabilities", limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "signal_samples", force: :cascade do |t|
    t.integer  "signal",          limit: 4,                           null: false
    t.decimal  "lat",                       precision: 15, scale: 13, null: false
    t.decimal  "lng",                       precision: 16, scale: 13, null: false
    t.integer  "access_point_id", limit: 4
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
  end

  add_index "signal_samples", ["access_point_id"], name: "index_signal_samples_on_access_point_id", using: :btree

end
