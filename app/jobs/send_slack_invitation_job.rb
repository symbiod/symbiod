class SendSlackInvitationJob < ApplicationJob
  queue_as :default

  def perform(email)
    puts "Slack invite"
  end
end
