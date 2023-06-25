class AddCategoryLabelToGoosearts < ActiveRecord::Migration[7.0]
  def change
    add_column :gosearts, :category_label, :string
  end
end
