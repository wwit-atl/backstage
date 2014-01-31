class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.string  :email, index: true
      t.string  :lastname, index: true
      t.string  :firstname, index: true
      t.string  :sex
      t.date    :dob
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
