class AddCapacityToShow < ActiveRecord::Migration
  def change
    add_column :shows, :capacity, :integer

    Konfig.create(
        name:  'DefaultShowCapacity',
        value: 123,
        desc:  'The default maximum occupancy for Shows (maximum tickets sold)'
    )
  end
end
