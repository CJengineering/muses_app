class CreateSummaries < ActiveRecord::Migration[7.0]
  def change
    create_table :summaries do |t|
      t.belongs_to :article, null: true, foreign_key: true
      t.belongs_to :goseart, null: true, foreign_key: true
      t.belongs_to :bing_article, null: true, foreign_key: true
      t.text :summary_text

      t.timestamps
    end
  end
end
