class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string     :subject
      t.text       :message
      t.integer    :sender_id
      t.integer    :approver_id
      t.datetime   :sent_at, index: true

      t.timestamps
    end

    create_table :members_messages, id: false do |t|
      t.references :member
      t.references :message
    end
  end
end
