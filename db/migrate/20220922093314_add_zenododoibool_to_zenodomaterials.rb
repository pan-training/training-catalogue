class AddZenododoiboolToZenodomaterials < ActiveRecord::Migration[5.2]
  def change
    add_column :zenodomaterials, :zenododoibool, :boolean
  end
end
