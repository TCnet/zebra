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

ActiveRecord::Schema.define(version: 20171010045243) do

  create_table "albums", force: :cascade do |t|
    t.string   "name"
    t.string   "summary"
    t.string   "coverimg"
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "csize"
    t.string   "ussize"
    t.string   "brand"
    t.text     "dnote"
    t.text     "description"
    t.string   "dname"
    t.string   "fullname"
    t.text     "keywords"
    t.text     "points"
    t.index ["user_id", "created_at"], name: "index_albums_on_user_id_and_created_at"
    t.index ["user_id"], name: "index_albums_on_user_id"
  end

  create_table "kwords", force: :cascade do |t|
    t.string   "name"
    t.text     "instr"
    t.text     "outstr"
    t.string   "lefwords"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_kwords_on_user_id"
  end

  create_table "microposts", force: :cascade do |t|
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "picture"
    t.index ["user_id", "created_at"], name: "index_microposts_on_user_id_and_created_at"
    t.index ["user_id"], name: "index_microposts_on_user_id"
  end

  create_table "photos", force: :cascade do |t|
    t.string   "name"
    t.integer  "album_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "picture"
    t.string   "qquuid"
    t.index ["album_id"], name: "index_photos_on_album_id"
  end

  create_table "products", force: :cascade do |t|
    t.string   "name"
    t.string   "sku"
    t.integer  "parentid"
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["user_id"], name: "index_products_on_user_id"
  end

  create_table "relationships", force: :cascade do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["followed_id"], name: "index_relationships_on_followed_id"
    t.index ["follower_id", "followed_id"], name: "index_relationships_on_follower_id_and_followed_id", unique: true
    t.index ["follower_id"], name: "index_relationships_on_follower_id"
  end

  create_table "upcs", force: :cascade do |t|
    t.string   "name"
    t.string   "bool"
    t.string   "isused"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_upcs_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "password_digest"
    t.string   "remember_digest"
    t.boolean  "admin"
    t.string   "activation_digest"
    t.boolean  "activated",         default: false
    t.datetime "activated_at"
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
    t.string   "brand"
    t.text     "note"
    t.string   "imgrule"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "xstockplans", force: :cascade do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_xstockplans_on_user_id"
  end

  create_table "xstocks", force: :cascade do |t|
    t.string   "sku"
    t.string   "fnsku"
    t.integer  "homenum"
    t.integer  "fbanum"
    t.integer  "monthsold"
    t.string   "parentsku"
    t.integer  "xstockplan_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "name"
    t.integer  "plannum"
    t.index ["xstockplan_id"], name: "index_xstocks_on_xstockplan_id"
  end

end
