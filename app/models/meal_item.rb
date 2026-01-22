class MealItem < ApplicationRecord
  belongs_to :meal, class_name: "Meal", foreign_key: :meal_id

  enum :status, { proposed: 0, confirmed: 1, substituted: 2, removed: 3 }

  validates :name, presence: true
  validates :cost, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
end
