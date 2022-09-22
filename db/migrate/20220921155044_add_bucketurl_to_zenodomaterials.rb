class AddBucketurlToZenodomaterials < ActiveRecord::Migration[5.2]
  def change
    add_column :zenodomaterials, :bucketurl, :string
  end
end
