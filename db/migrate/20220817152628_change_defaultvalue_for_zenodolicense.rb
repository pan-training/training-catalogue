class ChangeDefaultvalueForZenodolicense < ActiveRecord::Migration[5.2]
  def change
    change_column_default :zenodomaterials, :zenodolicense, from: "notspecified", to: "CC-BY-4.0"   
  end
end
