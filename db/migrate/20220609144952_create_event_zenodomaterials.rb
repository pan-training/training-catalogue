class CreateEventZenodomaterials < ActiveRecord::Migration[5.2]
  def change
    create_table :event_zenodomaterials do |t|
      t.references :event, index: true, foreign_key: true
      t.references :zenodomaterial, index: true, foreign_key: true    
    end
  end
end
