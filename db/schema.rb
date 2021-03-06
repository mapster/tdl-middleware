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

ActiveRecord::Schema.define(version: 20171024221536) do

  create_table "exercises", force: :cascade do |t|
    t.string   "name"
    t.string   "title"
    t.string   "kind"
    t.integer  "difficulty"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "solutions", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "exercise_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "solutions", ["exercise_id"], name: "index_solutions_on_exercise_id"
  add_index "solutions", ["user_id"], name: "index_solutions_on_user_id"

  create_table "solve_attempts", force: :cascade do |t|
    t.integer  "solution_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.text     "report"
  end

  add_index "solve_attempts", ["solution_id"], name: "index_solve_attempts_on_solution_id"

  create_table "source_files", force: :cascade do |t|
    t.string   "name"
    t.text     "contents"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "source_set_id"
    t.string   "source_set_type"
  end

  add_index "source_files", ["source_set_type", "source_set_id"], name: "index_source_files_on_source_set_type_and_source_set_id"

  create_table "user_authorizations", force: :cascade do |t|
    t.integer  "user_id",                               null: false
    t.boolean  "manage_exercises",      default: false, null: false
    t.boolean  "manage_users",          default: false, null: false
    t.boolean  "manage_authorizations", default: false, null: false
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  add_index "user_authorizations", ["user_id"], name: "index_user_authorizations_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "single_access_token"
    t.string   "perishable_token"
    t.integer  "login_count",         default: 0,     null: false
    t.integer  "failed_login_count",  default: 0,     null: false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.boolean  "active",              default: false
    t.boolean  "approved",            default: false
    t.boolean  "confirmed",           default: false
  end

  add_index "users", ["perishable_token"], name: "index_users_on_perishable_token", unique: true
  add_index "users", ["persistence_token"], name: "index_users_on_persistence_token", unique: true
  add_index "users", ["single_access_token"], name: "index_users_on_single_access_token", unique: true

end
