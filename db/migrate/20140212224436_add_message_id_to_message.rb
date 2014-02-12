class AddMessageIdToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :email_message_id, :string, index: true
  end
end
