class Event < ApplicationRecord
  enum :status, { planned: 0, doing: 1, done: 2 }

  validates :title, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true

  scope :upcoming, -> { where("start_time > ?", Time.current).order(start_time: :asc) }

  # Search scope
  scope :search, ->(query) {
    return all if query.blank?
    where("title ILIKE ? OR description ILIKE ?", "%#{query}%", "%#{query}%")
  }

  # Filter scopes
  scope :by_type, ->(type) { where(type: type) if type.present? }
  scope :by_status, ->(status) { where(status: status) if status.present? }
  scope :by_time_range, ->(range) {
    case range
    when "today"
      where(start_time: Time.current.all_day)
    when "week"
      where(start_time: Time.current.all_week)
    when "month"
      where(start_time: Time.current.all_month)
    when "next_week"
      where(start_time: 1.week.from_now.all_week)
    else
      all
    end
  }

  belongs_to :parent_event, class_name: "Event", optional: true
  has_many :recurring_instances, class_name: "Event", foreign_key: "parent_event_id"

  acts_as_list scope: [ :status ]

  serialize :recurrence_rule, coder: YAML

  validates :cost, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
end
