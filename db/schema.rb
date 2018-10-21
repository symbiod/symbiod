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

ActiveRecord::Schema.define(version: 2018_10_20_153821) do

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

  create_table "data_migrations", primary_key: "version", id: :string, force: :cascade do |t|
  end

  create_table "ideas", force: :cascade do |t|
    t.string "name", null: false
    t.text "description", null: false
    t.integer "author_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "private_project", default: false
    t.boolean "skip_bootstrapping", default: false
    t.string "state", null: false
    t.index ["author_id"], name: "index_ideas_on_author_id"
  end

  create_table "legacy_roles", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_legacy_roles_on_name_and_resource_type_and_resource_id"
    t.index ["resource_type", "resource_id"], name: "index_legacy_roles_on_resource_type_and_resource_id"
  end

  create_table "member_onboarding_feedback_questions", force: :cascade do |t|
    t.string "description", null: false
    t.string "key_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key_name"], name: "index_member_onboarding_feedback_questions_on_key_name", unique: true
  end

  create_table "member_onboarding_survey_responses", force: :cascade do |t|
    t.jsonb "feedback", null: false
    t.bigint "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id"], name: "index_member_onboarding_survey_responses_on_role_id", unique: true
  end

  create_table "member_onboardings", force: :cascade do |t|
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "feedback_status"
    t.string "slack_status"
    t.string "github_status"
  end

  create_table "member_test_task_assignments", force: :cascade do |t|
    t.integer "test_task_id", null: false
    t.integer "test_task_result_id"
    t.integer "member_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "feedback"
  end

  create_table "member_test_task_results", force: :cascade do |t|
    t.string "link", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "member_test_tasks", force: :cascade do |t|
    t.text "description", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title", null: false
    t.integer "position"
    t.string "state"
    t.integer "skill_id"
    t.string "role_name"
    t.index ["skill_id"], name: "index_member_test_tasks_on_skill_id"
  end

  create_table "notes", force: :cascade do |t|
    t.text "content"
    t.integer "noteable_id"
    t.string "noteable_type"
    t.integer "commenter_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commenter_id"], name: "index_notes_on_commenter_id"
    t.index ["noteable_type", "noteable_id"], name: "index_notes_on_noteable_type_and_noteable_id"
  end

  create_table "project_users", force: :cascade do |t|
    t.bigint "project_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "mentor", default: false
    t.index ["project_id", "user_id"], name: "index_project_users_on_project_id_and_user_id", unique: true
    t.index ["project_id"], name: "index_project_users_on_project_id"
    t.index ["user_id"], name: "index_project_users_on_user_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name", null: false
    t.integer "idea_id", null: false
    t.string "slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "stack_id"
    t.index ["idea_id"], name: "index_projects_on_idea_id"
    t.index ["slug"], name: "index_projects_on_slug", unique: true
    t.index ["stack_id"], name: "index_projects_on_stack_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "type"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "state"
    t.datetime "last_screening_followup_date", default: -> { "CURRENT_TIMESTAMP" }
    t.datetime "last_unfinished_survey_followup_date", default: -> { "CURRENT_TIMESTAMP" }
    t.integer "unfinished_survey_followup_counter", default: 0
    t.index ["type", "user_id"], name: "index_roles_on_type_and_user_id"
    t.index ["type"], name: "index_roles_on_type"
    t.index ["user_id"], name: "index_roles_on_user_id"
  end

  create_table "skills", force: :cascade do |t|
    t.string "title", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "state"
  end

  create_table "stack_skills", force: :cascade do |t|
    t.bigint "stack_id"
    t.bigint "skill_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["skill_id"], name: "index_stack_skills_on_skill_id"
    t.index ["stack_id"], name: "index_stack_skills_on_stack_id"
  end

  create_table "stacks", force: :cascade do |t|
    t.string "name", null: false
    t.string "identifier", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identifier"], name: "index_stacks_on_identifier"
  end

  create_table "user_skills", force: :cascade do |t|
    t.boolean "primary", default: false
    t.bigint "skill_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["skill_id"], name: "index_user_skills_on_skill_id"
    t.index ["user_id"], name: "index_user_skills_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "github"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "crypted_password"
    t.string "salt"
    t.string "first_name"
    t.string "last_name"
    t.string "location"
    t.string "timezone"
    t.string "cv_url"
    t.integer "approver_id"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  create_table "votes", force: :cascade do |t|
    t.string "vote_type", null: false
    t.integer "idea_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["idea_id"], name: "index_votes_on_idea_id"
    t.index ["user_id"], name: "index_votes_on_user_id"
  end

  add_foreign_key "member_onboarding_survey_responses", "roles"
  add_foreign_key "project_users", "projects"
  add_foreign_key "project_users", "users"
  add_foreign_key "projects", "stacks"
  add_foreign_key "stack_skills", "skills"
  add_foreign_key "stack_skills", "stacks"
  add_foreign_key "user_skills", "skills"
  add_foreign_key "user_skills", "users"
end
