class AddCategoryToArticles < ActiveRecord::Migration[7.0]
  def change
    add_column :articles, :category_label, :string
  end
end
