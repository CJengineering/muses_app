class CreateKeyWords < ActiveRecord::Migration[7.0]
  def change
    create_table :key_words do |t|
      t.text :key_word
      t.string :rss_url

      t.timestamps
    end
  end
end
