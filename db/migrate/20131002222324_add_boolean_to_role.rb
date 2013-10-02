class AddBooleanToRole < ActiveRecord::Migration
  def change
    add_column :roles, :cast, :boolean
    add_column :roles, :crew, :boolean
  end
end
