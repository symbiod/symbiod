# Preview all emails at http://localhost:3000/rails/mailers/developer/send_followup/notify
class Developer::SendFollowupPreview < ActionMailer::Preview
  def notify
    Developer::SendFollowupMailer.notify(User.first)
  end
end
