# Preview all emails at http://localhost:3000/rails/mailers/staff/screening_uncomplited_reminder
class Staff::ScreeningUncomplitedReminderPreview < ActionMailer::Preview
  def notify
    Staff::ScreeningUncomplitedReminderMailer.notify(User.first)
  end
end
