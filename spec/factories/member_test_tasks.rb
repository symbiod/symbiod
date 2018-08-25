# frozen_string_literal: true

FactoryBot.define do
  factory :member_test_task, class: 'Member::TestTask' do
    title { Faker::VForVendetta.quote }
    position { %w[1 2].sample }
    description { Faker::VForVendetta.speech }
    state 'active'
    skill
    role_name 'mentor'

    trait :first_position do
      position 1
    end

    trait :second_position do
      position 2
    end

    trait :disabled do
      state 'disabled'
    end
  end
end
