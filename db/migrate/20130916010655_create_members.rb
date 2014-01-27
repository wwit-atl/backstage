class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.string  :email
      t.string  :lastname
      t.string  :firstname
      t.string  :sex
      t.date    :dob
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
