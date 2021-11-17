class AddOrcidToProfiles < ActiveRecord::Migration[5.2]
  def change
    add_column :profiles, :orcid, :string
  end
end
