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

ActiveRecord::Schema.define(version: 20160820072259) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "appointments", force: :cascade do |t|
    t.integer  "school_id"
    t.integer  "book_id"
    t.integer  "status",       default: 0
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.datetime "promise_date"
  end

  create_table "books", force: :cascade do |t|
    t.text     "field"
    t.text     "title"
    t.text     "isbn"
    t.decimal  "ori_price"
    t.decimal  "ratio"
    t.integer  "stock",      default: 1
    t.text     "remark"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "deprecated", default: false
  end

  create_table "records", force: :cascade do |t|
    t.integer  "subject"
    t.integer  "verb"
    t.integer  "object"
    t.text     "adverb"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.text     "fullname"
    t.text     "school_id"
    t.text     "phone"
    t.text     "email"
    t.text     "password"
    t.text     "grad_year"
    t.decimal  "credit",     default: 0.0
    t.text     "remark"
    t.boolean  "verified"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "role",       default: 1
  end

end
