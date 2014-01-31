class CreateKonfigs < ActiveRecord::Migration
  def change
    create_table :konfigs do |t|
      t.string :name, index: true
      t.string :value, index: true
      t.string :desc

      t.timestamps
    end
  end
end
