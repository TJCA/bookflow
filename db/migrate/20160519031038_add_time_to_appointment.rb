class AddTimeToAppointment < ActiveRecord::Migration
  def change
    add_column :appointments, :promise_date, :datetime
  end
end
