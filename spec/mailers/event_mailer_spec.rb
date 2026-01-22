require "rails_helper"

RSpec.describe EventMailer, type: :mailer do
  describe "reminder" do
    let(:user) { create(:user) }
    let(:event) { create(:event, start_time: 1.day.from_now) }
    let(:mail) { EventMailer.reminder(event, user) }

    it "renders the headers" do
      expect(mail.subject).to include("Reminder: #{event.title}")
      expect(mail.to).to eq([ user.email ])
      expect(mail.from).to eq([ "from@example.com" ])
    end

    it "renders the body" do
      expect(mail.body.encoded).to include(user.name)
      expect(mail.body.encoded).to include(event.title)
      expect(mail.body.encoded).to include(event_url(event))
    end
  end
end
