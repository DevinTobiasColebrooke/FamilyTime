class AddPositionToEvents < ActiveRecord::Migration[8.0]
  def change
    add_column :events, :position, :integer
  end
end
