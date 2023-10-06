class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :posts do |t|
      t.belongs_to :key_word, null: false, foreign_key: true
      t.string :title
      t.string :published
      t.text :link
      t.string :category_label
      t.integer :score
      t.integer :score_second
      t.string :source

      t.timestamps
    end
  end
end
