class AddPublicationdateToZenodomaterials < ActiveRecord::Migration[5.2]
  def change
    add_column :zenodomaterials, :publicationdate, :date
  end
end
