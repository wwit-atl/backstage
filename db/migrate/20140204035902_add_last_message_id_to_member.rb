class AddLastMessageIdToMember < ActiveRecord::Migration
  def change
    add_column :members, :last_message_id, :integer, index: true
  end
end
