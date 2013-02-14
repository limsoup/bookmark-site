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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130214004758) do

  create_table "bookmark_urls", :force => true do |t|
    t.string   "url"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "playlists", :force => true do |t|
    t.string   "playlist_name"
    t.integer  "user_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "playlists", ["user_id"], :name => "index_playlists_on_user_id"

  create_table "user_bookmarks", :force => true do |t|
    t.string   "bookmark_name"
    t.integer  "playlist_id"
    t.integer  "bookmark_url_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "user_bookmarks", ["bookmark_url_id"], :name => "index_user_bookmarks_on_bookmark_url_id"
  add_index "user_bookmarks", ["playlist_id"], :name => "index_user_bookmarks_on_playlist_id"

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.string   "bookmarklet_user_key"
  end

  add_index "users", ["bookmarklet_user_key"], :name => "index_users_on_bookmarklet_user_key"
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
