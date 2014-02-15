class AddGroupIdToShows < ActiveRecord::Migration
  def change
    add_column :shows, :group_id, :integer, index: true
    add_column :show_templates, :group_id, :integer, index: true
  end
end
