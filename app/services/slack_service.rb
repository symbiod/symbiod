class SlackService
  def initialize
  end

  def invite(email, first_name, last_name)
    SlackIntegration::InviteUser.new(email, first_name, last_name).call
  end

  def post_to_channel(channel, message)
  end

  def invite_to_channel(channel, email)
  end

  def create_channel(channel_name)
  end
end
