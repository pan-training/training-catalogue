class AddUserIdToUnscrapeds < ActiveRecord::Migration[5.2]
  def change
      add_reference :unscrapeds, :user, index: true, foreign_key: true
  end
end
