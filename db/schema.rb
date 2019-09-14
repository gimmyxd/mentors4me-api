# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_09_14_152130) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "contexts", id: :serial, force: :cascade do |t|
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status"
    t.integer "mentor_id"
    t.integer "organization_id"
    t.index ["mentor_id"], name: "index_contexts_on_mentor_id"
    t.index ["organization_id"], name: "index_contexts_on_organization_id"
  end

  create_table "mentors", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "phone_number"
    t.string "linkedin"
    t.string "facebook"
    t.string "city"
    t.text "description"
    t.integer "user_id"
    t.string "organization"
    t.string "position"
    t.string "occupation"
    t.float "availability"
    t.index ["user_id"], name: "index_mentors_on_user_id"
  end

  create_table "messages", id: :serial, force: :cascade do |t|
    t.integer "context_id"
    t.text "message"
    t.integer "sender_id"
    t.integer "receiver_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "uuid", null: false
    t.boolean "seen", default: false, null: false
    t.index ["context_id"], name: "index_messages_on_context_id"
    t.index ["uuid"], name: "index_messages_on_uuid", unique: true
  end

  create_table "organizations", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "asignee"
    t.string "phone_number"
    t.string "city"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.string "facebook"
    t.index ["user_id"], name: "index_organizations_on_user_id"
  end

  create_table "proposals", id: :serial, force: :cascade do |t|
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "auth_token"
    t.datetime "auth_token_created_at"
    t.string "proposer_first_name"
    t.string "proposer_last_name"
    t.string "proposer_email"
    t.string "proposer_phone_number"
    t.string "mentor_first_name"
    t.string "mentor_organization"
    t.string "mentor_email"
    t.string "mentor_phone_number"
    t.string "mentor_facebook"
    t.string "mentor_linkedin"
    t.text "reason"
    t.string "mentor_last_name"
    t.index ["auth_token"], name: "index_proposals_on_auth_token", unique: true
  end

  create_table "role_assignments", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id"], name: "index_role_assignments_on_role_id"
    t.index ["user_id"], name: "index_role_assignments_on_user_id"
  end

  create_table "roles", id: :serial, force: :cascade do |t|
    t.string "slug"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_roles_on_slug", unique: true
  end

  create_table "skill_assignments", id: :serial, force: :cascade do |t|
    t.integer "mentor_id"
    t.integer "skill_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mentor_id"], name: "index_skill_assignments_on_mentor_id"
    t.index ["skill_id"], name: "index_skill_assignments_on_skill_id"
  end

  create_table "skills", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "auth_token"
    t.datetime "auth_token_created_at"
    t.boolean "active", default: true
    t.index ["auth_token"], name: "index_users_on_auth_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "mentors", "users"
  add_foreign_key "messages", "contexts"
  add_foreign_key "organizations", "users"
end
