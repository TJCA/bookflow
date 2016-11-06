class SetAppointmentDefaultStatus < ActiveRecord::Migration
  def change
    change_column :appointments, :status, :integer, :default => 0
  end
end
