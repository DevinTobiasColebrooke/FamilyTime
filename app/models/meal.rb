class Meal < Event
  has_many :meal_items, foreign_key: :meal_id, dependent: :destroy
end
