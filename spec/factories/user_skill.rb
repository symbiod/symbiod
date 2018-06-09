# frozen_string_literal: true

FactoryBot.define do
  factory :user_skill do
    primary false
    skill { create(:skill) }
    user { create(:user) }
  end

  trait :primary do
    primary true
  end
end
