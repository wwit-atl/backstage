class CreatePhones < ActiveRecord::Migration
  def change
    create_table :phones do |t|
      t.integer :member_id
      t.string :number
      t.string :ntype

      t.timestamps
    end
  end
end
