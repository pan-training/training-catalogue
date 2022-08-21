class RenameLanguageToZenodolanguage < ActiveRecord::Migration[5.2]
  def change
      rename_column :zenodomaterials, :language, :zenodolanguage
  end
end
