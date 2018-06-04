# frozen_string_literal: true

FactoryBot.define do
  factory :user, aliases: %i[author developer] do
    email { Faker::Internet.email }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    location { Faker::Address.country }
    timezone { Faker::Address.time_zone }
    cv_url { Faker::Internet.url }
    state 'pending'
    password 'password'
    salt { 'ExqpVWiDcK2vGfeRjqTx' }
    crypted_password { Sorcery::CryptoProviders::BCrypt.encrypt('password', salt) }

    trait :pending

    trait :policy_accepted do
      state 'policy_accepted'
    end

    trait :profile_completed do
      state 'profile_completed'
    end

    trait :active do
      state 'active'
    end

    trait :disabled do
      state 'disabled'
    end

    trait :rejected do
      state 'rejected'
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
