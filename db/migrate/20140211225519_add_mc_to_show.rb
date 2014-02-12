class AddMcToShow < ActiveRecord::Migration
  def change
    add_column :shows, :mc_id, :integer, index: true
  end
end
