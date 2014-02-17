class AddTrainingToShifts < ActiveRecord::Migration
  def change
    add_column :shifts, :training, :boolean
  end
end
