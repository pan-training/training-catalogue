class CreateBauthor < ActiveRecord::Migration[5.2]
  def change
    create_table :bauthors do |t|
      t.string :firstname
      t.string :lastname
    end
  end
end
