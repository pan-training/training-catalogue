class CreateEventunscrapeds < ActiveRecord::Migration[5.2]
  def change
    create_table :eventunscrapeds do |t|
      t.string :title
      t.string :url
      t.string :slug
      
      t.timestamps
    end
    add_index :eventunscrapeds, :slug, unique: true
    add_reference :eventunscrapeds, :user, index: true, foreign_key: true
  end
end
