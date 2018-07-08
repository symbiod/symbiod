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

    trait :developer do
      after(:create) do |user|
        user.add_role(:developer)
      end
    end

    trait :mentor do
      after(:create) do |user|
        user.add_role(:mentor)
      end
    end

    trait :author do
      after(:create) do |user|
        user.add_role(:author)
      end
    end

    trait :staff_or_mentor do
      after(:create) do |user|
        user.add_role(%i[staff mentor].sample)
      end
    end

    trait :developer_or_author do
      after(:create) do |user|
        user.add_role(%i[developer author].sample)
      end
    end

    trait :with_idea do
      after(:create) do |user|
        create(:idea, author: user)
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

    trait :slack_user do
      email 'user@test.com'
      first_name 'User'
      last_name 'Last'
    end

    trait :with_primary_skill do
      transient do
        skill_name nil
      end

      # Allow to pass custom skill name to the user factory
      after(:create) do |user, options|
        skill_name = options.skill_name || "#{Faker::Job.field}-#{Time.now.to_f}"
        skill = Skill.find_or_create_by(title: skill_name)
        create(:user_skill, :primary, skill: skill, user: user)
      end
    end
  end
end
