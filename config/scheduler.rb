# frozen_string_literal: true

require 'clockwork'
require_relative '../config/boot'
require_relative '../config/environment'

module Clockwork
  every(1.day, 'SendFollowupJob', at: Settings.sheduler.time) do
    Screening::SendFollowupJob.perform_later
  end
end
