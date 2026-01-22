class Activity < Event
  has_many :activity_ratings, foreign_key: :activity_id, dependent: :destroy
end
