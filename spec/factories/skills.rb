# frozen_string_literal: true

require 'yaml'

FactoryBot.define do
  factory :skill do
    title { "#{Faker::Job.key_skill}-#{Time.now.to_f}" }
  end
end
