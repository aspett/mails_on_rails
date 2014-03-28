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

ActiveRecord::Schema.define(version: 20140328000547) do

  create_table "mail_routes", force: true do |t|
    t.string   "name"
    t.string   "company"
    t.string   "transport_type"
    t.float    "maximum_weight"
    t.float    "maximum_volume"
    t.integer  "priority"
    t.float    "cost_per_weight"
    t.float    "cost_per_volume"
    t.float    "price_per_weight"
    t.float    "price_per_volume"
    t.integer  "origin_id"
    t.integer  "destination_id"
    t.integer  "duration"
    t.integer  "frequency"
    t.datetime "start_date"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "places", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string "username"
    t.string "password_digest"
    t.string "role"
  end

end
