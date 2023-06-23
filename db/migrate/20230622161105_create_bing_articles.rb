class CreateBingArticles < ActiveRecord::Migration[7.0]
  def change
    create_table :bing_articles do |t|
      t.belongs_to :key_word, null: false, foreign_key: true
      t.string :title
      t.string :category_label
      t.integer :score
      t.integer :score_second
      t.string :published
      t.text :link

      t.timestamps
    end
  end
end
