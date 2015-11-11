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

ActiveRecord::Schema.define(version: 20151005224226) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.integer  "key",        default: 0, null: false
    t.string   "detail"
    t.integer  "project_id",             null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "activities", ["project_id"], name: "index_activities_on_project_id", using: :btree

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "experiments", force: :cascade do |t|
    t.string   "name",                 null: false
    t.money    "price",      scale: 2, null: false
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "project_experiments", force: :cascade do |t|
    t.integer  "project_id",    null: false
    t.integer  "experiment_id", null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "project_experiments", ["experiment_id"], name: "index_project_experiments_on_experiment_id", using: :btree
  add_index "project_experiments", ["project_id"], name: "index_project_experiments_on_project_id", using: :btree

  create_table "projects", force: :cascade do |t|
    t.string   "name",                                              null: false
    t.string   "slug",                                              null: false
    t.boolean  "is_open_source",                    default: true,  null: false
    t.boolean  "is_featured",                       default: false, null: false
    t.integer  "status",                            default: 0,     null: false
    t.string   "icon_url_path",                                     null: false
    t.integer  "user_id",                                           null: false
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.string   "gen_bank",                                          null: false
    t.binary   "gen_bank_content",                                  null: false
    t.money    "price",                   scale: 2
    t.integer  "estimated_delivery_days"
    t.string   "report"
    t.binary   "report_content"
  end

  add_index "projects", ["slug"], name: "index_projects_on_slug", using: :btree
  add_index "projects", ["user_id"], name: "index_projects_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "username",                               null: false
    t.integer  "status",                 default: 1,     null: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "admin",                  default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", using: :btree
  add_index "users", ["username"], name: "index_users_on_username", using: :btree

  add_foreign_key "activities", "projects", on_delete: :cascade
  add_foreign_key "project_experiments", "experiments", on_delete: :cascade
  add_foreign_key "project_experiments", "projects", on_delete: :cascade
  add_foreign_key "projects", "users", on_delete: :cascade
end
