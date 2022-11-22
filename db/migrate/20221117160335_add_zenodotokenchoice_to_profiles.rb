class AddZenodotokenchoiceToProfiles < ActiveRecord::Migration[5.2]
  def change
    add_column :profiles, :zenodotokenchoice, :boolean
  end
end
