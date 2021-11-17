class CreateBcontributors < ActiveRecord::Migration[5.2]
  def change
    create_table :bcontributors do |t|
      t.string :firstname
      t.string :lastname
      t.string :orcid
    end
  end
end
