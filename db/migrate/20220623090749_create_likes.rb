class CreateLikes < ActiveRecord::Migration[5.2]
  def change
    create_table :likes do |t|      
      t.references :user, index: true, foreign_key: true
      t.references :resource, polymorphic: true, index: true
      t.timestamps null: false
    end
  end
end
