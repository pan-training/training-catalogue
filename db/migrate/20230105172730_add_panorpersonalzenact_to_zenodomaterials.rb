class AddPanorpersonalzenactToZenodomaterials < ActiveRecord::Migration[5.2]
  def change
    add_column :zenodomaterials, :panorpersonalzenact, :boolean
  end
end
