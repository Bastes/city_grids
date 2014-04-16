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

ActiveRecord::Schema.define(version: 20140416095748) do

  create_table "cities", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cities", ["name"], name: "index_cities_on_name", unique: true, using: :btree

  create_table "tickets", force: true do |t|
    t.string   "email"
    t.string   "nickname"
    t.integer  "tournament_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "admin"
    t.string   "status"
  end

  add_index "tickets", ["status"], name: "index_tickets_on_status", using: :btree
  add_index "tickets", ["tournament_id"], name: "index_tickets_on_tournament_id", using: :btree

  create_table "tournaments", force: true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "organizer_email"
    t.string   "organizer_nickname"
    t.integer  "places"
    t.datetime "begins_at"
    t.text     "abstract"
    t.integer  "city_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "admin"
    t.boolean  "activated",          default: false
    t.datetime "ends_at"
  end

  add_index "tournaments", ["activated"], name: "index_tournaments_on_activated", using: :btree
  add_index "tournaments", ["city_id"], name: "index_tournaments_on_city_id", using: :btree

end
