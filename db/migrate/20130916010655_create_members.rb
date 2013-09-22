class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.string :username
      t.string :lastname
      t.string :firstname
      t.string :email

      t.timestamps
    end
  end
end
