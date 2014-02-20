class AddCompanyMemberToRoles < ActiveRecord::Migration
  def change
    add_column :roles, :cm, :boolean
  end
end
