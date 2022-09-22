class AddZenodoidsToZenodomaterials < ActiveRecord::Migration[5.2]
  def change
    add_column :zenodomaterials, :zenodoid, :integer
    add_column :zenodomaterials, :zenodolatestid, :integer
  end
end
