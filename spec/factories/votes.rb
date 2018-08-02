# frozen_string_literal: true

FactoryBot.define do
  factory :vote do
    vote_type 'up'
    idea
    user
  end

  trait :down do
    vote_type 'down'
  end
end
