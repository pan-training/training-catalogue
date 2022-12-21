class RenameLicenceToZenodolicense < ActiveRecord::Migration[5.2]
  def change
      rename_column :zenodomaterials, :licence, :zenodolicense
  end
end
