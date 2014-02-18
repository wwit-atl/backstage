class AddScheduleToRoles < ActiveRecord::Migration
  def change
    add_column :roles, :schedule, :boolean
  end
end
