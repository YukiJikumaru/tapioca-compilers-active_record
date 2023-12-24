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

ActiveRecord::Schema[7.1].define(version: 2023_10_21_172138) do
  create_table "authors", charset: "utf8mb4", comment: "authors", force: :cascade do |t|
    t.string "name", null: false, comment: "author's name"
    t.string "tel", comment: "author's telephone number"
    t.string "email", comment: "author's email address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "post_tag_relations", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "post_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_post_tag_relations_on_post_id"
    t.index ["tag_id"], name: "index_post_tag_relations_on_tag_id"
  end

  create_table "posts", charset: "utf8mb4", comment: "posts", force: :cascade do |t|
    t.bigint "author_id"
    t.string "title", null: false
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_posts_on_author_id"
  end

  create_table "table_ones", charset: "utf8mb4", force: :cascade do |t|
    t.string "string_non_null", null: false
    t.string "string_nullable"
    t.integer "integer_non_null", null: false
    t.integer "integer_nullable"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tags", charset: "utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "post_tag_relations", "posts", on_delete: :cascade
  add_foreign_key "post_tag_relations", "tags", on_delete: :cascade
  add_foreign_key "posts", "authors", on_delete: :nullify
end
