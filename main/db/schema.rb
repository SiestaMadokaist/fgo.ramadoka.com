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

ActiveRecord::Schema.define(version: 20170212154640) do

  create_table "material_servants", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "material_id", null: false
    t.integer  "servant_id",  null: false
    t.integer  "classifier",  null: false
    t.integer  "count",       null: false
    t.integer  "level",       null: false
    t.index ["material_id", "servant_id", "classifier", "level"], name: "fk1", unique: true, using: :btree
  end

  create_table "materials", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "name",       null: false
    t.string   "slug",       null: false
    t.index ["slug"], name: "index_materials_on_slug", unique: true, using: :btree
  end

  create_table "servant_users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "servant_id", null: false
    t.integer  "user_id",    null: false
  end

  create_table "servants", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "klass",      null: false
    t.integer  "star",       null: false
    t.string   "name",       null: false
    t.string   "slug",       null: false
    t.index ["slug"], name: "index_servants_on_slug", unique: true, using: :btree
  end

  create_table "user_auths", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "origin",                            null: false
    t.string   "origin_id",                         null: false
    t.integer  "user_id"
    t.boolean  "validated",         default: false, null: false
    t.string   "validation_token"
    t.datetime "validation_expiry"
    t.index ["origin", "origin_id"], name: "index_user_auths_on_origin_and_origin_id", unique: true, using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "name",       null: false
    t.string   "password",   null: false
  end

end
