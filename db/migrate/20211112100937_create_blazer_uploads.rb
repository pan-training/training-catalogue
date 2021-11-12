class CreateBlazerUploads < ActiveRecord::Migration[5.2]
  def change
    create_table :blazer_uploads do |t|
      t.references :creator
      t.string :table
      t.text :description
      t.timestamps null: false
    end
  end
end
