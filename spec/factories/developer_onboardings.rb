# frozen_string_literal: true

FactoryBot.define do
  factory :developer_onboarding, class: 'Developer::Onboarding' do
    user
    slack false
    github false

    trait :invited_to_slack do
      slack true
    end

    trait :invited_to_github do
      github true
    end
  end
end
