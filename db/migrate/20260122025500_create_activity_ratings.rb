class CreateActivityRatings < ActiveRecord::Migration[8.0]
  def change
    create_table :activity_ratings do |t|
      t.integer :activity_id
      t.integer :user_id
      t.integer :score
      t.string :note

      t.timestamps
    end
  end
end
