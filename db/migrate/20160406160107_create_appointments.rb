class CreateAppointments < ActiveRecord::Migration
  def change
    create_table :appointments do |t|
      t.integer :user
      t.integer :item
      t.integer :status

      t.timestamps null: false
    end
  end
end
