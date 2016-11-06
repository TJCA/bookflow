class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.text :field
      t.text :title
      t.text :isbn
      t.decimal :ori_price
      t.decimal :ratio
      t.integer :stock
      t.text :remark

      t.timestamps null: false
    end
  end
end
