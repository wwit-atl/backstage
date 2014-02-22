class AddUuidToShifts < ActiveRecord::Migration
  def change
    add_column :shifts, :uuid, :string
  end
end
