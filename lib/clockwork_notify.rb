require 'clockwork'
require_relative '../config/boot'
require_relative '../config/environment'

module Clockwork
  every(1.day, 'SendFollowupMailer'){
    Developer::SendFollowupMailer.notify(user.id).deliver_now
  }
end