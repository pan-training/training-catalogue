class CreateJoinTableBcontributorMaterial < ActiveRecord::Migration[5.2]
  def change
    create_join_table :bcontributors, :materials do |t|
       t.index [:bcontributor_id, :material_id],  name: 'bcontrib_material_join'
       t.index [:material_id, :bcontributor_id],  name: 'material_bcontrib_join'
    end
  end
end
