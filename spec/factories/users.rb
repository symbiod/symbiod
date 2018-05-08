# frozen_string_literal: true

FactoryBot.define do
  factory :user, aliases: %i[author developer] do
    email { Faker::Internet.email }
    state 'pending'
    password 'password'
    salt { 'ExqpVWiDcK2vGfeRjqTx' }
    crypted_password { Sorcery::CryptoProviders::BCrypt.encrypt('password', salt) }

    trait :with_name do
      name { Faker::Name.name }
    end

    trait :pending

    trait :active do
      state 'active'
    end

    trait :screening_completed do
      state 'screening_completed'
    end

    trait :staff do
      after(:create) do |user|
        user.add_role(:staff)
      end
    end

    trait :with_assignment do
      after(:create) do |user|
        create(:developer_test_task_assignment, :uncompleted, developer: user)
      end
    end

    trait :authenticated_through_github do
      after(:create) do |user|
        create(:authentication, :github, user: user)
      end
    end
  end
end
