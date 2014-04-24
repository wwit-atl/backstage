class AddHiddenToShifts < ActiveRecord::Migration
  def change
    add_column :shifts, :hidden, :boolean, default: false
  end
end
