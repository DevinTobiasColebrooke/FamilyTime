class EventMailer < ApplicationMailer
  def reminder(event, user)
    @event = event
    @user = user

    mail to: user.email, subject: "Reminder: #{@event.title} is tomorrow!"
  end
end
