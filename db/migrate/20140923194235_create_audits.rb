class CreateAudits < ActiveRecord::Migration
  def change
    create_table :audits do |t|
      t.string :ident
      t.text :message
      t.references :member, index: true

      t.timestamps
    end
  end
end
