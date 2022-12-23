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

ActiveRecord::Schema.define(version: 20151229175019) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "actors_shows", id: false, force: :cascade do |t|
    t.integer "member_id"
    t.integer "show_id"
  end

  add_index "actors_shows", ["member_id"], name: "index_actors_shows_on_member_id", using: :btree
  add_index "actors_shows", ["show_id"], name: "index_actors_shows_on_show_id", using: :btree

  create_table "addresses", force: :cascade do |t|
    t.string   "street1"
    t.string   "street2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "atype"
    t.integer  "member_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "addresses", ["member_id"], name: "index_addresses_on_member_id", using: :btree

  create_table "api_keys", force: :cascade do |t|
    t.string   "access_token"
    t.string   "note"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "audits", force: :cascade do |t|
    t.string   "ident"
    t.text     "message"
    t.integer  "member_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "audits", ["member_id"], name: "index_audits_on_member_id", using: :btree

  create_table "conflicts", force: :cascade do |t|
    t.integer  "year"
    t.integer  "month"
    t.integer  "day"
    t.integer  "member_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "lock"
  end

  add_index "conflicts", ["member_id"], name: "index_conflicts_on_member_id", using: :btree

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

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "konfigs", force: :cascade do |t|
    t.string   "name"
    t.string   "value"
    t.string   "desc"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "konfigs", ["name"], name: "index_konfigs_on_name", using: :btree
  add_index "konfigs", ["value"], name: "index_konfigs_on_value", using: :btree

  create_table "members", force: :cascade do |t|
    t.string   "email"
    t.string   "lastname"
    t.string   "firstname"
    t.string   "sex"
    t.date     "dob"
    t.boolean  "active",                 default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "last_message_id"
    t.string   "slug"
    t.boolean  "superuser"
    t.boolean  "conflict_exempt",        default: false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  add_index "members", ["email"], name: "index_members_on_email", using: :btree
  add_index "members", ["firstname"], name: "index_members_on_firstname", using: :btree
  add_index "members", ["lastname"], name: "index_members_on_lastname", using: :btree
  add_index "members", ["reset_password_token"], name: "index_members_on_reset_password_token", unique: true, using: :btree
  add_index "members", ["slug"], name: "index_members_on_slug", unique: true, using: :btree

  create_table "members_messages", id: false, force: :cascade do |t|
    t.integer "member_id"
    t.integer "message_id"
  end

  create_table "members_roles", id: false, force: :cascade do |t|
    t.integer "member_id"
    t.integer "role_id"
  end

  add_index "members_roles", ["member_id", "role_id"], name: "index_members_roles_on_member_id_and_role_id", using: :btree

  create_table "members_skills", id: false, force: :cascade do |t|
    t.integer "member_id"
    t.integer "skill_id"
  end

  add_index "members_skills", ["member_id"], name: "index_members_skills_on_member_id", using: :btree
  add_index "members_skills", ["skill_id"], name: "index_members_skills_on_skill_id", using: :btree

  create_table "messages", force: :cascade do |t|
    t.string   "subject"
    t.text     "message"
    t.integer  "sender_id"
    t.integer  "approver_id"
    t.datetime "sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "delivered_at"
    t.string   "email_message_id"
    t.datetime "approved_at"
  end

  add_index "messages", ["sent_at"], name: "index_messages_on_sent_at", using: :btree

  create_table "notes", force: :cascade do |t|
    t.text     "content"
    t.integer  "member_id"
    t.integer  "notable_id"
    t.string   "notable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notes", ["member_id"], name: "index_notes_on_member_id", using: :btree
  add_index "notes", ["notable_id", "notable_type"], name: "index_notes_on_notable_id_and_notable_type", using: :btree

  create_table "phones", force: :cascade do |t|
    t.string   "number"
    t.string   "ntype"
    t.integer  "member_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "phones", ["member_id"], name: "index_phones_on_member_id", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.string   "desc"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "cast"
    t.boolean  "crew"
    t.string   "title"
    t.boolean  "schedule"
    t.boolean  "cm"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "scenes", force: :cascade do |t|
    t.integer  "act"
    t.integer  "position"
    t.text     "suggestion"
    t.integer  "show_id"
    t.integer  "stage_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "shifts", force: :cascade do |t|
    t.integer "show_id"
    t.integer "skill_id"
    t.integer "member_id"
    t.boolean "training"
    t.string  "uuid"
    t.boolean "hidden",    default: false
  end

  add_index "shifts", ["member_id"], name: "index_shifts_on_member_id", using: :btree
  add_index "shifts", ["show_id"], name: "index_shifts_on_show_id", using: :btree
  add_index "shifts", ["skill_id"], name: "index_shifts_on_skill_id", using: :btree

  create_table "show_templates", force: :cascade do |t|
    t.string   "name"
    t.integer  "dow"
    t.time     "showtime"
    t.time     "calltime"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "group_id"
  end

  create_table "show_templates_skills", id: false, force: :cascade do |t|
    t.integer "show_template_id"
    t.integer "skill_id"
  end

  create_table "shows", force: :cascade do |t|
    t.string   "name"
    t.date     "date"
    t.time     "showtime"
    t.time     "calltime"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "mc_id"
    t.integer  "group_id"
    t.datetime "casting_sent_at"
    t.hstore   "tickets"
    t.integer  "capacity"
  end

  add_index "shows", ["date"], name: "index_shows_on_date", using: :btree

  create_table "skills", force: :cascade do |t|
    t.string   "code"
    t.string   "name"
    t.integer  "priority"
    t.text     "description"
    t.boolean  "training"
    t.boolean  "autocrew"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "limits",      default: true
  end

  add_index "skills", ["code"], name: "index_skills_on_code", using: :btree
  add_index "skills", ["name"], name: "index_skills_on_name", using: :btree
  add_index "skills", ["priority"], name: "index_skills_on_priority", using: :btree

  create_table "stages", force: :cascade do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
