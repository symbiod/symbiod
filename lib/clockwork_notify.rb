require 'clockwork'
require_relative '../config/boot'
require_relative '../config/environment'

module Clockwork
  every(3.day, 'SendFollowupJob'){
    Developer::SendFollowupJob.perform_later
  }
end