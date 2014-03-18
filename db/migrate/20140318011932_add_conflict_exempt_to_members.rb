class AddConflictExemptToMembers < ActiveRecord::Migration
  def change
    add_column :members, :conflict_exempt, :boolean, default: false
  end
end
