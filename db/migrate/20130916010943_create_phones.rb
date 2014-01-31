class CreatePhones < ActiveRecord::Migration
  def change
    create_table :phones do |t|
      t.string :number
      t.string :ntype
      t.references :member, index: true

      t.timestamps
    end
  end
end
