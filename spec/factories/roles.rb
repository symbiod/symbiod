# frozen_string_literal: true

FactoryBot.define do
  factory :role do
    user
    type 'Roles::Developer'

    # traits by role type
    trait :developer do
      initialize_with { Roles::Developer.new(attributes) }
      type 'Roles::Developer'
    end

    trait :mentor do
      initialize_with { Roles::Mentor.new(attributes) }
      type 'Roles::Mentor'
    end

    trait :author do
      initialize_with { Roles::Author.new(attributes) }
      type 'Roles::Author'
    end

    trait :staff do
      initialize_with { Roles::Staff.new(attributes) }
      type 'Roles::Staff'
    end

    # traits by state
    trait :pending do
      state 'pending'
    end

    trait :policy_accepted do
      state 'policy_accepted'
    end

    trait :active do
      state 'active'
    end

    trait :disabled do
      state 'disabled'
    end

    trait :profile_completed do
      state 'profile_completed'
    end

    trait :screening_completed do
      state 'screening_completed'
    end

    trait :rejected do
      state 'rejected'
    end
  end
end
