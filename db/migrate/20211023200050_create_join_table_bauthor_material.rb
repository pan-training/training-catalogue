class CreateJoinTableBauthorMaterial < ActiveRecord::Migration[5.2]
  def change
    create_join_table :bauthors, :materials do |t|
       t.index [:bauthor_id, :material_id]
       t.index [:material_id, :bauthor_id]
    end
  end
end
