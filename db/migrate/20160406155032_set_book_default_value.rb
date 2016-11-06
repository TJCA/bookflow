class SetBookDefaultValue < ActiveRecord::Migration
  def change
      change_column :books, :deprecated, :boolean, :default => false
      change_column :books, :stock, :integer, :default => 1
  end
end
