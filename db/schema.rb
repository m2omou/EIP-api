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

ActiveRecord::Schema.define(version: 20140227081352) do

  create_table "advertisings", force: true do |t|
    t.integer  "place_id"
    t.integer  "company_id"
    t.string   "title"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "api_keys", force: true do |t|
    t.string   "access_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "companies", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "address"
    t.string   "sector"
    t.string   "logo"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "media", force: true do |t|
    t.integer  "type"
    t.string   "url"
    t.string   "server"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "place_messages", force: true do |t|
    t.integer  "place_id"
    t.integer  "user_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "places", force: true do |t|
    t.string   "foursquare_id"
    t.float    "longitude"
    t.float    "latitude"
    t.string   "name"
    t.string   "postcode"
    t.string   "city"
    t.string   "address"
    t.string   "country"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "publications", force: true do |t|
    t.integer  "user_id"
    t.integer  "place_id"
    t.string   "title"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "file"
  end

  create_table "relationships", force: true do |t|
    t.integer  "user_id"
    t.integer  "place_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reports", force: true do |t|
    t.integer  "publication_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "username"
    t.string   "firstname"
    t.string   "lastname"
    t.string   "email"
    t.string   "avatar"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_hash"
    t.string   "password_salt"
    t.string   "auth_token"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
  end

  create_table "votes", force: true do |t|
    t.integer  "publication_id"
    t.integer  "user_id"
    t.boolean  "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
