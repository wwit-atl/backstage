class CreateWwitdocuments < ActiveRecord::Migration
  def change
    create_table :wwitdocuments do |t|
      t.string :doc_name
      t.string :attachment
    end
  end
end
