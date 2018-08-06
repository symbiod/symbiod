# frozen_string_literal: true

require 'clockwork'
require_relative '../config/boot'
require_relative '../config/environment'

module Clockwork
  every(3.day, 'SendFollowupJob', at: '10:00') do
    Developer::Screening::SendFollowupJob.perform_later
  end
end
