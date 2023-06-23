class AddScoreToArticles < ActiveRecord::Migration[7.0]
  def change
    add_column :articles, :score, :integer
  end
end
