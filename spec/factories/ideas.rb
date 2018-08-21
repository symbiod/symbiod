# frozen_string_literal: true

FactoryBot.define do
  factory :idea do
    name { Faker::Company.bs }
    description 'Description'
    private_project false
    skip_bootstrapping false
    author
  end

  trait :private_project do
    private_project true
  end

  trait :skip_bootstrapping do
    skip_bootstrapping true
  end

  trait :voting do
    state 'voting'
  end

  trait :active do
    state 'active'
  end

  trait :disabled do
    state 'disabled'
  end

  trait :pending do
    state 'pending'
  end

  trait :rejected do
    state 'rejected'
  end

  trait :not_voting do
    state %w[pending active disabled].sample
  end

  trait :all_states do
    state %w[pending active disabled voting].sample
  end

  trait :with_project do
    after(:create) do |idea|
      create(:project, idea: idea)
    end
  end
end
