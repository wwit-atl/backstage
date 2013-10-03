class CreateScenes < ActiveRecord::Migration
  def change
    create_table :scenes do |t|
      t.integer :act
      t.integer :position
      t.text    :suggestion
      t.references :show
      t.references :stage

      t.timestamps
    end
  end
end
