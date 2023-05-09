class CreateFactivaArticles < ActiveRecord::Migration[7.0]
  def change
    create_table :factiva_articles do |t|
      t.string :title
      t.text :description
      t.text :factiva_link
      t.datetime :published
      t.boolean :posted , default: :false
      t.text :url_g_1
      t.text :url_g_2
      t.belongs_to :key_word, null: false, foreign_key: true
      t.timestamps
    end
  end
end
