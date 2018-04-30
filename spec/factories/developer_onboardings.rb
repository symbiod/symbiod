# frozen_string_literal: true

FactoryBot.define do
  factory :developer_onboarding, class: 'Developer::Onboarding' do
    user
    slack false
    github false
  end
end
