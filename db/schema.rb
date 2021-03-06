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

ActiveRecord::Schema.define(version: 20150630025852) do

  create_table "cleaning_entries", force: true do |t|
    t.string   "name"
    t.integer  "draw_no"
    t.integer  "join_flag"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "user_id"
    t.string   "pass"
    t.string   "email"
  end

  create_table "draw_results", force: true do |t|
    t.integer  "vacuum_id"
    t.integer  "wipe_id"
    t.integer  "result_flag"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
