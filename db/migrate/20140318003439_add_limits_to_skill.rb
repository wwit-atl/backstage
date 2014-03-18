class AddLimitsToSkill < ActiveRecord::Migration
  def change
    add_column :skills, :limits, :boolean, default: true
  end
end
