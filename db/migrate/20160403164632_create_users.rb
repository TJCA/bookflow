class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.text :fullname
      t.text :school_id
      t.text :phone
      t.text :email
      t.text :password
      t.text :grad_year
      t.decimal :credit
      t.text :remark
      t.boolean :verified

      t.timestamps null: false
    end
  end
end
