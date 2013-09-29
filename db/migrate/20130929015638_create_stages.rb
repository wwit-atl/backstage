class CreateStages < ActiveRecord::Migration
  def change
    create_table :stages do |t|
      t.string :code
      t.string :name

      t.timestamps
    end
  end
end
