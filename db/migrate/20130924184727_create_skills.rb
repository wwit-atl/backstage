class CreateSkills < ActiveRecord::Migration
  def change
    create_table :skills do |t|
      t.string  :name, index: true
      t.string  :description
      t.boolean :training?

      t.timestamps
    end

    create_table( :members_skills, id: false ) do |t|
      t.references :member
      t.references :skill
      t.index [:member_id, :skill_id]
      t.index [:skill_id, :member_id]
    end

    add_index(:skills, :name)
  end
end
