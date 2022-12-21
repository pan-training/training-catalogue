class AddTypeToBcontributors < ActiveRecord::Migration[5.2]
  def change
    add_column :bcontributors, :type, :string,default: "Other" 
  end
end
