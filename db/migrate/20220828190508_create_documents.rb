class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.string :doc_name
      t.attachment :avatar
    end
  end
end
