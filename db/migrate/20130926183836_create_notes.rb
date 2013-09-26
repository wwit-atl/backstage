class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.text :content
      t.references :member, index: true
      t.belongs_to :notable, polymorphic: true

      t.timestamps
    end
    add_index :notes, [:notable_id, :notable_type]
  end
end
