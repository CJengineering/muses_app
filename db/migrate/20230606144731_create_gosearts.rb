class CreateGosearts < ActiveRecord::Migration[7.0]
  def change
    create_table :gosearts do |t|
      t.belongs_to :key_word, null: false, foreign_key: true
      t.text :title
      t.text :url_link
      t.integer :score
      t.integer :score_second

      t.timestamps
    end
  end
end
