class AddFactivaToKeyWords < ActiveRecord::Migration[7.0]
  def change
    add_column :key_words, :factiva, :boolean
  end
end
