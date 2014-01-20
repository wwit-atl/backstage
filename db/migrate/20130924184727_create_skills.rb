class CreateSkills < ActiveRecord::Migration
  def change
    create_table :skills do |t|
      t.string  :code, index: true
      t.string  :name, index: true
      t.string  :category
      t.integer :priority
      t.text    :description
      t.boolean :training
      t.boolean :autocrew
      t.boolean :ranked

      t.timestamps
    end

    create_table( :members_skills, id: false ) do |t|
      t.references :member, index: true
      t.references :skill, index: true
    end

  end
end
