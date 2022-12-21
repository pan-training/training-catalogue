class CreateJoinTableBcontributorZenodomaterial < ActiveRecord::Migration[5.2]
  def change
    create_join_table :bcontributors, :zenodomaterials do |t|
       t.index [:bcontributor_id, :zenodomaterial_id], name:'index_bcontrib_zmaterials_on_bcontrib_id_and_zmaterial_id'
       t.index [:zenodomaterial_id, :bcontributor_id], name:'index_zmaterials_bcontrib_on_zmaterial_id_and_bcontrib_id'
    end  
  end
end
