class RecurrenceService
  def initialize(event)
    @event = event
  end

  def generate_instances
    return unless @event.recurrence_rule.present?

    # For simplicity, assume recurrence_rule is a simple string key for now: 'weekly', 'monthly'
    # Or strict IceCube rule if we parse it.

    # MVP Implementation:
    # We will use simple logic: If recurrence_rule is 'weekly', create next 4 instances.
    # If 'monthly', create next 3 instances.

    count = 0
    interval = nil

    case @event.recurrence_rule
    when "weekly"
      count = 4
      interval = 1.week
    when "monthly"
      count = 3
      interval = 1.month
    end

    return unless interval

    (1..count).each do |i|
      offset = interval * i
      new_start = @event.start_time + offset
      new_end = @event.end_time + offset

      Event.create!(
        type: @event.type,
        title: @event.title,
        description: @event.description,
        start_time: new_start,
        end_time: new_end,
        status: :planned,
        parent_event_id: @event.id,
        recurrence_rule: nil # Instances don't recurse themselves to avoid infinite loops
      )
    end
  end
end
