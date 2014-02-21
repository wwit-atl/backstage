class AddLockToConflicts < ActiveRecord::Migration
  def change
    add_column :conflicts, :lock, :boolean
  end
end
