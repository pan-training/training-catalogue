class AddImagetypeToZenodomaterials < ActiveRecord::Migration[5.2]
  def change
    add_column :zenodomaterials, :imagetype, :string
  end
end
