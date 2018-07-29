# frozen_string_literal: true

FactoryBot.define do
  factory :role do
    user

    trait :developer do
      initialize_with { Roles::Developer.new(attributes) }
    end

    trait :mentor do
      initialize_with { Roles::Mentor.new(attributes) }
    end

    trait :author do
      initialize_with { Roles::Author.new(attributes) }
    end

    trait :staff do
      initialize_with { Roles::Staff.new(attributes) }
    end
  end
end
