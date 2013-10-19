class CreateShows < ActiveRecord::Migration
  def change
    create_table :shows do |t|
      t.name :name
      t.date :date
      t.time :showtime
      t.time :calltime

      t.timestamps
    end
    add_index(:shows, :date)
  end
end
