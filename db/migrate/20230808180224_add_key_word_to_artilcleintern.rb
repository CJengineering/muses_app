class AddKeyWordToArtilcleintern < ActiveRecord::Migration[7.0]
  def change
    add_column :articleinterns, :keyword, :string
    add_reference :articleinterns, :key_word, foreign_key: true, optional: true
  end
end
