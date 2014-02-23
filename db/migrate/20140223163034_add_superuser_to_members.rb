class AddSuperuserToMembers < ActiveRecord::Migration
  def change
    add_column :members, :superuser, :boolean, index: true
  end
end
