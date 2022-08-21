class CreateJoinTableBauthorZenodomaterial < ActiveRecord::Migration[5.2]
  def change
    create_join_table :bauthors, :zenodomaterials do |t|
       t.index [:bauthor_id, :zenodomaterial_id], name:'index_bauth_zmaterials_on_bauth_id_and_zmaterial_id'
       t.index [:zenodomaterial_id, :bauthor_id], name:'index_zmaterials_bauth_on_zmaterial_id_and_bauth_id'
    end  
  end
end
