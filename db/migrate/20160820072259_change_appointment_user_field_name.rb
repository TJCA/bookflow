class ChangeAppointmentUserFieldName < ActiveRecord::Migration
  def change
    rename_column :appointments, :user, :school_id
  end
end
