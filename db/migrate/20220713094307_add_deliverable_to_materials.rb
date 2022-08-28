class AddDeliverableToMaterials < ActiveRecord::Migration[5.2]
  def change
    add_column :materials, :deliverable, :string
  end
end
