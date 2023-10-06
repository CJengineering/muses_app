class ChangeNullConstraintForArticleinternInSummaries < ActiveRecord::Migration[7.0]
  def change
    change_column :summaries, :articleintern_id, :bigint, null: true
  end
end
