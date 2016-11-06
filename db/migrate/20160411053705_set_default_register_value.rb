class SetDefaultRegisterValue < ActiveRecord::Migration
  def change
      change_column :users, :credit, :numeric, :default => 0.0
      # 1 represents ordinary user
      change_column :users, :role, :integer, :default => 1
  end
end
