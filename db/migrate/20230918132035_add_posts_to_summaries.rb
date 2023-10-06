class AddPostsToSummaries < ActiveRecord::Migration[7.0]
  def change
    add_reference :summaries, :post, null: true, foreign_key: true
  end
end
