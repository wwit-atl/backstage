class AddTicketsToShow < ActiveRecord::Migration
  enable_extension 'hstore' unless extension_enabled?('hstore')

  def change
    add_column :shows, :tickets, :hstore
  end
end
