class AddCostToEventsAndMealItems < ActiveRecord::Migration[8.0]
  def change
    add_column :events, :cost, :decimal, precision: 10, scale: 2, default: 0.0
    add_column :meal_items, :cost, :decimal, precision: 10, scale: 2, default: 0.0
  end
end
