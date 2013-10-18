class CreateConflicts < ActiveRecord::Migration
  def change
    create_table :conflicts do |t|
      t.integer :year
      t.integer :month
      t.integer :day
      t.references :member, index: true

      t.timestamps
    end
  end
end
