require 'rails_helper'

RSpec.describe EventReminderJob, type: :job do
  include ActiveJob::TestHelper

  let!(:user) { create(:user) }
  let!(:event_tomorrow) { create(:event, start_time: 1.day.from_now + 2.hours, end_time: 1.day.from_now + 3.hours) }
  let!(:event_later) { create(:event, start_time: 3.days.from_now) }

  it "queues emails for events happening tomorrow" do
    expect {
      EventReminderJob.perform_now
    }.to have_enqueued_job(ActionMailer::MailDeliveryJob).with(
      "EventMailer", "reminder", "deliver_now", args: [ event_tomorrow, user ]
    )
  end

  it "does not queue emails for events not happening tomorrow" do
    EventReminderJob.perform_now

    # We expect 1 job for event_tomorrow, but 0 for event_later
    enqueued_jobs = ActiveJob::Base.queue_adapter.enqueued_jobs

    # Filter jobs for this specific mailer
    mail_jobs = enqueued_jobs.select { |j| j[:job] == ActionMailer::MailDeliveryJob }

    # Check that none of the args match event_later
    later_event_jobs = mail_jobs.select do |job|
      args = job[:args]
      # args structure: [mailer_class, method, delivery_method, {args: [event, user]}]
      args[3]["args"][0]["_aj_globalid"].include?(event_later.id.to_s)
    end

    expect(later_event_jobs).to be_empty
  end
end
