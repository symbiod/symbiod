# frozen_string_literal: true

FactoryBot.define do
  factory :developer_test_task, class: 'Developer::TestTask' do
    title { "#{Faker::VForVendetta.quote} #{Time.now.to_f}" }
    position { %w[1 2].sample }
    description { Faker::VForVendetta.speech }
    state 'active'
    skill
    role

    trait :disabled do
      state 'disabled'
    end
  end
end
