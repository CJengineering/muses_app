class CreateArticleinterns < ActiveRecord::Migration[7.0]
  def change
    create_table :articleinterns do |t|
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
