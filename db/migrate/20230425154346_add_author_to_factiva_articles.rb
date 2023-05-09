class AddAuthorToFactivaArticles < ActiveRecord::Migration[7.0]
  def change
    add_column :factiva_articles, :author, :string
  end
end
