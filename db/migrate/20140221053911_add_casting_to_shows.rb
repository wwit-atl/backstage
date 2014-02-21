class AddCastingToShows < ActiveRecord::Migration
  def change
    add_column :shows, :casting_sent_at, :datetime
  end
end
