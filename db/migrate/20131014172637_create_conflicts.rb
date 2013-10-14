class CreateConflicts < ActiveRecord::Migration
  def change
    create_table :conflicts do |t|
      t.string :date
      t.references :member, index: true

      t.timestamps
    end
  end
end
