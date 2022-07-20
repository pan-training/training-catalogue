class AddDeliverableToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :deliverable, :string
  end
end
