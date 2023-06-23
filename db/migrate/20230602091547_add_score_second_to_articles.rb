class AddScoreSecondToArticles < ActiveRecord::Migration[7.0]
  def change
    add_column :articles, :score_second, :integer
  end
end
