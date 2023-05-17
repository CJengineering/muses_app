class RenameTypeToTypeContent < ActiveRecord::Migration[7.0]
  def change
    rename_column :media, :type, :type_content
  end
end
