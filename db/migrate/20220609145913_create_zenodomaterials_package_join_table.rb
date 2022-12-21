class CreateZenodomaterialsPackageJoinTable < ActiveRecord::Migration[5.2]
  def change
     create_table :package_zenodomaterials, id: false do |t|
       t.integer :zenodomaterial_id, index: true
       t.integer :package_id, index: true
       t.timestamps null: false
     end    
  end
end
