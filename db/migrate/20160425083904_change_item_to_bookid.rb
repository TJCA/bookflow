class ChangeItemToBookid < ActiveRecord::Migration
  def change
    rename_column :appointments, :item, :book_id
  end
end
