class AddDeprecatedToBook < ActiveRecord::Migration
  def change
    add_column :books, :deprecated, :boolean
  end
end
