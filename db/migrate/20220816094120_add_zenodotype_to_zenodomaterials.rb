class AddZenodotypeToZenodomaterials < ActiveRecord::Migration[5.2]
  def change
    add_column :zenodomaterials, :zenodotype, :string
  end
end
