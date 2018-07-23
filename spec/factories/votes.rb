# frozen_string_literal: true

FactoryBot.define do
  factory :vote do
    vote_type 'up'
    idea { create(:idea, :voting) }
    user { create(:user, :developer, :active) }
  end

  trait :down do
    vote_type 'down'
  end
end
