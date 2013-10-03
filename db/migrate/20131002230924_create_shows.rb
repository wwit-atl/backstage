class CreateShows < ActiveRecord::Migration
  def change
    create_table :shows do |t|
      t.date :date
      t.time :showtime
      t.time :calltime

      t.timestamps
    end

    create_table( :members_shows, id: false ) do |t|
      t.references :member
      t.references :show
    end

    add_index(:shows, :date)
    add_index(:members_shows, [ :member_id, :show_id ])
  end
end
