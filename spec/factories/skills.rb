# frozen_string_literal: true

FactoryBot.define do
  factory :skill do
    title { "#{Faker::Job.key_skill}-#{Time.now.to_f}" }
    state 'active'

    trait :disabled do
      state 'disabled'
    end
  end
end
