class AddLanguageToMaterials < ActiveRecord::Migration[5.2]
  def change
    add_column :materials, :language, :string, default: "English"
  end
end
