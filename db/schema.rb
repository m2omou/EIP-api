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

ActiveRecord::Schema.define(version: 20140526213838) do

create_table "alpha_users", force: true do |t|
    t.string   "email"
    t.datetime "subscribe_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uuid"
  end

  create_table "api_keys", force: true do |t|
    t.string   "access_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", force: true do |t|
    t.text     "content"
    t.integer  "publication_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "conversations", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "creator_id"
    t.integer  "recipient_id"
  end

  create_table "followed_places", force: true do |t|
    t.integer  "user_id"
    t.string   "place_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", force: true do |t|
    t.text     "content"
    t.integer  "sender_id"
    t.integer  "conversation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "places", force: true do |t|
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
    t.string   "place_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "user_longitude"
    t.float    "user_latitude"
    t.integer  "type"
    t.string   "url"
    t.string   "thumb_url"
    t.string   "file"
  end

  create_table "report_comments", force: true do |t|
    t.integer  "comment_id"
    t.integer  "reason"
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "report_publications", force: true do |t|
    t.integer  "publication_id"
    t.integer  "reason"
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "settings", force: true do |t|
    t.boolean  "allow_messages",                 default: true
    t.boolean  "send_notification_for_comments", default: true
    t.boolean  "send_notification_for_messages", default: true
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
