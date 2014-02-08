class AddDeliveredAtToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :delivered_at, :datetime, index: true
  end
end
