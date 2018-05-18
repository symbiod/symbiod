# frozen_string_literal: true

FactoryBot.define do
  factory :developer_onboarding, class: 'Developer::Onboarding' do
    user
    slack false
    github false

    trait :slack_invited do
      slack true
    end

    trait :github_invited do
      github true
    end
  end
end
