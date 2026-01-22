class EventReminderJob < ApplicationJob
  queue_as :default

  def perform
    # Find all events starting tomorrow
    tomorrow_start = 1.day.from_now.beginning_of_day
    tomorrow_end = 1.day.from_now.end_of_day

    events = Event.where(start_time: tomorrow_start..tomorrow_end)

    return if events.empty?

    # For simplicity in this family app, we notify ALL users about ALL events
    # In a real app, you might only notify attendees
    users = User.all

    events.each do |event|
      users.each do |user|
        EventMailer.reminder(event, user).deliver_later
      end
    end
  end
end
