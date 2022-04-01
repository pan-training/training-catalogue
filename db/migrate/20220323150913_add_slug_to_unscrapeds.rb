class AddSlugToUnscrapeds < ActiveRecord::Migration[5.2]
  def change
  
    add_column :unscrapeds, :slug, :string
    add_index :unscrapeds, :slug, unique: true
  
  end
end
