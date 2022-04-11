class CreateUnscrapeds < ActiveRecord::Migration[5.2]
  def change
    create_table :unscrapeds do |t|
      t.text :title
      t.string :url
      t.string :short_description

      t.timestamps
    end
  end
end
