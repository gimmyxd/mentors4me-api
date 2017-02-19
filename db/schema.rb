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

ActiveRecord::Schema.define(version: 20170219121111) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "contexts", force: :cascade do |t|
    t.text     "description"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "status"
    t.integer  "mentor_id"
    t.integer  "organization_id"
    t.index ["mentor_id"], name: "index_contexts_on_mentor_id", using: :btree
    t.index ["organization_id"], name: "index_contexts_on_organization_id", using: :btree
  end

  create_table "mentors", force: :cascade do |t|
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone_number"
    t.string   "linkedin"
    t.string   "facebook"
    t.string   "city"
    t.text     "description"
    t.integer  "user_id"
    t.index ["user_id"], name: "index_mentors_on_user_id", using: :btree
  end

  create_table "messages", force: :cascade do |t|
    t.integer  "context_id"
    t.text     "message"
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["context_id"], name: "index_messages_on_context_id", using: :btree
  end

  create_table "organizations", force: :cascade do |t|
    t.string   "name"
    t.string   "asignee"
    t.string   "phone_number"
    t.string   "city"
    t.text     "description"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "user_id"
    t.string   "facebook"
    t.index ["user_id"], name: "index_organizations_on_user_id", using: :btree
  end

  create_table "proposals", force: :cascade do |t|
    t.string   "status"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.string   "auth_token"
    t.datetime "auth_token_created_at"
    t.string   "proposer_first_name"
    t.string   "proposer_last_name"
    t.string   "proposer_email"
    t.string   "proposer_phone_number"
    t.string   "mentor_first_name"
    t.string   "mentor_organization"
    t.string   "mentor_email"
    t.string   "mentor_phone_number"
    t.string   "mentor_facebook"
    t.string   "mentor_linkedin"
    t.text     "reason"
    t.string   "mentor_last_name"
    t.index ["auth_token"], name: "index_proposals_on_auth_token", unique: true, using: :btree
  end

  create_table "role_assignments", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id"], name: "index_role_assignments_on_role_id", using: :btree
    t.index ["user_id"], name: "index_role_assignments_on_user_id", using: :btree
  end

  create_table "roles", force: :cascade do |t|
    t.string   "slug"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["slug"], name: "index_roles_on_slug", unique: true, using: :btree
  end

  create_table "skill_assignments", force: :cascade do |t|
    t.integer  "mentor_id"
    t.integer  "skill_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mentor_id"], name: "index_skill_assignments_on_mentor_id", using: :btree
    t.index ["skill_id"], name: "index_skill_assignments_on_skill_id", using: :btree
  end

  create_table "skills", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                 default: "",   null: false
    t.string   "encrypted_password",    default: "",   null: false
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "auth_token"
    t.datetime "auth_token_created_at"
    t.boolean  "active",                default: true
    t.index ["auth_token"], name: "index_users_on_auth_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
  end

  add_foreign_key "mentors", "users"
  add_foreign_key "messages", "contexts"
  add_foreign_key "organizations", "users"
end
