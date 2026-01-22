class ActivityRating < ApplicationRecord
  belongs_to :activity, class_name: "Activity", foreign_key: :activity_id
  belongs_to :user

  validates :score, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
end
