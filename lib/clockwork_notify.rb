require 'clockwork'
require_relative '../config/boot'
require_relative '../config/environment'

module Clockwork
  @users = User.all
  @users.each do |user|
    every(3.day, 'SendFollowupMailer'){
      Developer::SendFollowupMailer.notify(user.id).deliver_now
    }
  end
end