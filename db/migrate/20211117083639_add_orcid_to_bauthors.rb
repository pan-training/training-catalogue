class AddOrcidToBauthors < ActiveRecord::Migration[5.2]
  def change
    add_column :bauthors, :orcid, :string
  end
end
