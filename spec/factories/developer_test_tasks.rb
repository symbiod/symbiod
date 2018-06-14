# frozen_string_literal: true

FactoryBot.define do
  factory :developer_test_task, class: 'Developer::TestTask' do
    title { Faker::VForVendetta.quote }
    position { %w[1 2].sample }
    description { Faker::VForVendetta.speech }
    state 'active'
    skill
    role

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
