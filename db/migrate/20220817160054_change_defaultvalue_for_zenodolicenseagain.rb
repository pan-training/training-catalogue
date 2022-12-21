class ChangeDefaultvalueForZenodolicenseagain < ActiveRecord::Migration[5.2]
  def change
    change_column_default :zenodomaterials, :zenodolicense, from: "CC-BY-4.0", to: nil
  end
end
