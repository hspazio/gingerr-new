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

ActiveRecord::Schema.define(version: 0) do

  create_table "apps", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "stability_score"
    t.integer  "signal_frequency"
  end

  create_table "endpoints", force: :cascade do |t|
    t.string   "ip"
    t.string   "hostname"
    t.string   "login"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "errors", force: :cascade do |t|
    t.integer  "signal_id"
    t.string   "name"
    t.string   "message"
    t.string   "file"
    t.text     "backtrace"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["signal_id"], name: "index_errors_on_signal_id"
  end

  create_table "signals", force: :cascade do |t|
    t.string   "type"
    t.integer  "pid"
    t.integer  "app_id"
    t.datetime "created_at"
    t.integer  "endpoint_id"
    t.index ["app_id"], name: "index_signals_on_app_id"
    t.index ["endpoint_id"], name: "index_signals_on_endpoint_id"
    t.index ["type"], name: "index_signals_on_type"
  end

end
