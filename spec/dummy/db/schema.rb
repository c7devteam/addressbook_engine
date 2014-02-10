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

ActiveRecord::Schema.define(version: 20140210205321) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "account_contact_groups_account_contacts", id: false, force: true do |t|
    t.integer "account_contact_group_id", null: false
    t.integer "account_contact_id",       null: false
  end

  create_table "accounts", force: true do |t|
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "addressbook_account_contact_addresses", force: true do |t|
    t.integer  "account_contact_id"
    t.string   "line_1"
    t.string   "line_2"
    t.string   "line_3"
    t.string   "zip"
    t.string   "city"
    t.string   "country"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "addressbook_account_contact_emails", force: true do |t|
    t.integer  "account_contact_id"
    t.string   "email"
    t.boolean  "preferred"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "addressbook_account_contact_groups", force: true do |t|
    t.string   "name"
    t.string   "account_id"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "owner_id"
    t.string   "owner_type"
  end

  create_table "addressbook_account_contact_telephones", force: true do |t|
    t.string   "number"
    t.integer  "account_contact_id"
    t.boolean  "preferred"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "addressbook_account_contacts", force: true do |t|
    t.integer  "account_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "title"
    t.string   "image"
    t.datetime "deleted_at"
    t.string   "usernotice"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "owner_id"
    t.string   "owner_type"
  end

  create_table "users", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
