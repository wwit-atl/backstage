class AddApprovedAtToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :approved_at, :datetime
  end
end
