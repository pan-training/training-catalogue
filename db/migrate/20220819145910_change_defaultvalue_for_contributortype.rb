class ChangeDefaultvalueForContributortype < ActiveRecord::Migration[5.2]
  def change
    change_column_default :bcontributors, :type, from: "Other", to: nil  
  end
end
