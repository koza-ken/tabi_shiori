# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2025_10_28_040940) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cards", force: :cascade do |t|
    t.string "name", limit: 50, null: false
    t.text "memo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.bigint "group_id"
    t.index ["group_id"], name: "index_cards_on_group_id"
    t.index ["user_id"], name: "index_cards_on_user_id"
    t.check_constraint "user_id IS NOT NULL AND group_id IS NULL OR user_id IS NULL AND group_id IS NOT NULL", name: "cards_must_belong_to_user_or_group"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name", limit: 20, null: false
    t.integer "display_order", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["display_order"], name: "index_categories_on_display_order", unique: true
  end

  create_table "group_memberships", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "group_id", null: false
    t.string "group_nickname", limit: 20
    t.string "role", default: "member", null: false
    t.string "guest_token", limit: 64
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id", "group_nickname"], name: "index_group_memberships_on_group_id_and_group_nickname", unique: true
    t.index ["group_id"], name: "index_group_memberships_on_group_id"
    t.index ["guest_token"], name: "index_group_memberships_on_guest_token"
    t.index ["user_id", "group_id"], name: "index_group_memberships_on_user_id_and_group_id", unique: true
    t.index ["user_id"], name: "index_group_memberships_on_user_id"
  end

  create_table "groups", force: :cascade do |t|
    t.integer "created_by_user_id", null: false
    t.string "name", limit: 30, null: false
    t.string "invite_token", limit: 64, null: false
    t.string "trip_name", limit: 50
    t.date "start_date"
    t.date "end_date"
    t.text "trip_memo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_user_id"], name: "index_groups_on_created_by_user_id"
    t.index ["invite_token"], name: "index_groups_on_invite_token", unique: true
    t.index ["start_date"], name: "index_groups_on_start_date"
  end

  create_table "spots", force: :cascade do |t|
    t.bigint "card_id", null: false
    t.string "name", limit: 50, null: false
    t.text "address"
    t.string "phone_number", limit: 20
    t.text "website_url"
    t.string "google_place_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "category_id", null: false
    t.index ["card_id"], name: "index_spots_on_card_id"
    t.index ["category_id"], name: "index_spots_on_category_id"
    t.index ["google_place_id"], name: "index_spots_on_google_place_id", unique: true, where: "(google_place_id IS NOT NULL)"
  end

  create_table "users", force: :cascade do |t|
    t.string "display_name", limit: 20
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "provider", limit: 64
    t.string "uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "cards", "groups"
  add_foreign_key "cards", "users"
  add_foreign_key "group_memberships", "groups"
  add_foreign_key "group_memberships", "users"
  add_foreign_key "groups", "users", column: "created_by_user_id"
  add_foreign_key "spots", "cards"
  add_foreign_key "spots", "categories"
end
