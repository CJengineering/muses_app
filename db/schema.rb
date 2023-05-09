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

ActiveRecord::Schema[7.0].define(version: 2023_04_25_154346) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "articles", force: :cascade do |t|
    t.bigint "key_word_id", null: false
    t.string "title"
    t.string "published"
    t.text "link"
    t.boolean "posted", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key_word_id"], name: "index_articles_on_key_word_id"
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

  create_table "key_words", force: :cascade do |t|
    t.text "key_word"
    t.string "rss_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "factiva"
  end

  add_foreign_key "articles", "key_words"
  add_foreign_key "factiva_articles", "key_words"
end
