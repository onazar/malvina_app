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

ActiveRecord::Schema.define(version: 20160129135026) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "costumes", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "costumes_parts", id: false, force: :cascade do |t|
    t.integer "costume_id"
    t.integer "part_id"
  end

  create_table "ordered_parts", force: :cascade do |t|
    t.integer  "ordered_part_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "order_id"
  end

  create_table "orders", force: :cascade do |t|
    t.date     "date"
    t.integer  "order_type",   default: 0
    t.string   "name"
    t.integer  "client_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.date     "return_date"
    t.string   "client_name"
    t.string   "client_phone"
    t.integer  "days_in_rent"
    t.string   "tbd"
  end

  create_table "part_types", force: :cascade do |t|
    t.string   "type_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "parts", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "part_type_id"
  end

end
