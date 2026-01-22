class AddRecurrenceToEvents < ActiveRecord::Migration[8.0]
  def change
    add_column :events, :recurrence_rule, :text
    add_column :events, :parent_event_id, :integer
  end
end
