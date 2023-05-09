class CreateArticles < ActiveRecord::Migration[7.0]
  def change
    create_table :articles do |t|
      t.belongs_to :key_word, null: false, foreign_key: true
      t.string :title
      t.string :published
      t.text :link
      t.boolean :posted, default: :false

      t.timestamps
    end
  end
end
