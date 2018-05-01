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

ActiveRecord::Schema.define(version: 2018_05_01_135240) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authentications", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "provider", null: false
    t.string "uid", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provider", "uid"], name: "index_authentications_on_provider_and_uid"
  end

  create_table "data_migrations", id: false, force: :cascade do |t|
    t.string "version", null: false
    t.index ["version"], name: "unique_data_migrations", unique: true
  end

  create_table "developer_onboardings", force: :cascade do |t|
    t.integer "user_id", null: false
    t.boolean "slack", default: false
    t.boolean "github", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "developer_test_task_assignments", force: :cascade do |t|
    t.integer "test_task_id"
    t.integer "test_task_result_id"
    t.integer "developer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "developer_test_task_results", force: :cascade do |t|
    t.string "link", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "developer_test_tasks", force: :cascade do |t|
    t.text "description", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ideas", force: :cascade do |t|
    t.string "name", null: false
    t.text "description", null: false
    t.integer "author_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_ideas_on_author_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name", null: false
    t.integer "idea_id", null: false
    t.string "slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["idea_id"], name: "index_projects_on_idea_id"
    t.index ["slug"], name: "index_projects_on_slug"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource_type_and_resource_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "name"
    t.string "github"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "state"
    t.string "crypted_password"
    t.string "salt"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

end
