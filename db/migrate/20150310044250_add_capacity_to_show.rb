class AddCapacityToShow < ActiveRecord::Migration
  def change
    add_column :shows, :capacity, :integer
  end
end
