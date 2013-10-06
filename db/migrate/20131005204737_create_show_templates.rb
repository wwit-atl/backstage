class CreateShowTemplates < ActiveRecord::Migration
  def change
    create_table :show_templates do |t|
      t.string :name
      t.integer :dow
      t.time :showtime
      t.time :calltime

      t.timestamps
    end

    create_table :show_templates_skills, id: false do |t|
      t.references :show_template
      t.references :skill
    end
  end
end
