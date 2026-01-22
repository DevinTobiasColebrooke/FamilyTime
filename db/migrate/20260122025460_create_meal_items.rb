class CreateMealItems < ActiveRecord::Migration[8.0]
  def change
    create_table :meal_items do |t|
      t.integer :meal_id
      t.string :name
      t.string :note
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
