class RemoveAuthorsandContributorsFromMaterials < ActiveRecord::Migration[5.2]
  def change
    remove_column :materials, :authors, :string
    remove_column :materials, :contributors, :string
  end
end
