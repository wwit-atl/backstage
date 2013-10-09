class CreateShifts < ActiveRecord::Migration
  def change
    create_table :shifts do |t|
      t.references :show, index: true
      t.references :skill, index: true
      t.references :member, index: true
    end
  end
end
