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

ActiveRecord::Schema[7.0].define(version: 2023_06_23_103944) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "articles", force: :cascade do |t|
    t.bigint "key_word_id", null: false
    t.string "title"
    t.string "published"
    t.text "link"
    t.boolean "posted", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "category_label"
    t.integer "score"
    t.integer "score_second"
    t.index ["key_word_id"], name: "index_articles_on_key_word_id"
  end

  create_table "bing_articles", force: :cascade do |t|
    t.bigint "key_word_id", null: false
    t.string "title"
    t.string "category_label"
    t.integer "score"
    t.integer "score_second"
    t.string "published"
    t.text "link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key_word_id"], name: "index_bing_articles_on_key_word_id"
  end

  create_table "devise_api_tokens", force: :cascade do |t|
    t.string "resource_owner_type", null: false
    t.bigint "resource_owner_id", null: false
    t.string "access_token", null: false
    t.string "refresh_token"
    t.integer "expires_in", null: false
    t.datetime "revoked_at"
    t.string "previous_refresh_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["access_token"], name: "index_devise_api_tokens_on_access_token"
    t.index ["previous_refresh_token"], name: "index_devise_api_tokens_on_previous_refresh_token"
    t.index ["refresh_token"], name: "index_devise_api_tokens_on_refresh_token"
    t.index ["resource_owner_type", "resource_owner_id"], name: "index_devise_api_tokens_on_resource_owner"
  end

  create_table "factiva_articles", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.text "factiva_link"
    t.datetime "published"
    t.boolean "posted", default: false
    t.text "url_g_1"
    t.text "url_g_2"
    t.bigint "key_word_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "author"
    t.index ["key_word_id"], name: "index_factiva_articles_on_key_word_id"
  end

  create_table "gosearts", force: :cascade do |t|
    t.bigint "key_word_id", null: false
    t.text "title"
    t.text "url_link"
    t.integer "score"
    t.integer "score_second"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "category_label"
    t.index ["key_word_id"], name: "index_gosearts_on_key_word_id"
  end

  create_table "key_words", force: :cascade do |t|
    t.text "key_word"
    t.string "rss_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "factiva"
  end

  create_table "media", force: :cascade do |t|
    t.string "title"
    t.datetime "date"
    t.string "type_content"
    t.string "people"
    t.string "programme"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "articles", "key_words"
  add_foreign_key "bing_articles", "key_words"
  add_foreign_key "factiva_articles", "key_words"
  add_foreign_key "gosearts", "key_words"
end
