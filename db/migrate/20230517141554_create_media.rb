class CreateMedia < ActiveRecord::Migration[7.0]
  def change
    create_table :media do |t|
      t.string :title
      t.datetime :date
      t.string :type
      t.string :people
      t.string :programme

      t.timestamps
    end
  end
end
