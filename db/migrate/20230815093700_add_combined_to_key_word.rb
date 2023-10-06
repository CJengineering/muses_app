class AddCombinedToKeyWord < ActiveRecord::Migration[7.0]
  def change
    add_column :key_words, :combined, :boolean, default: false
  end
end
