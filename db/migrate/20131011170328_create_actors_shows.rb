class CreateActorsShows < ActiveRecord::Migration
  def change
    create_table :actors_shows, id: false do |t|
      t.references :member, index: true
      t.references :show, index: true
    end
  end
end
