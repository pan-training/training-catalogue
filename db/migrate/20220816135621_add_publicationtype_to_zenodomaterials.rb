class AddPublicationtypeToZenodomaterials < ActiveRecord::Migration[5.2]
  def change
    add_column :zenodomaterials, :publicationtype, :string
  end
end
