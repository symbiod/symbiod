# frozen_string_literal: true

FactoryBot.define do
  # TODO: remove this aliases, since the user does not represent role anymore
  factory :user, aliases: %i[author member] do
    email { Faker::Internet.email }
    github { Faker::Name.last_name }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    location { Faker::Address.country }
    timezone { Faker::Address.time_zone }
    cv_url { Faker::Internet.url }
    password 'password'
    salt { 'ExqpVWiDcK2vGfeRjqTx' }
    crypted_password { Sorcery::CryptoProviders::BCrypt.encrypt('password', salt) }

    # TODO: this ugly approach is added just for backward compatibility
    # We need to get rid of it, in favor of one user - multiple roles approach
    trait :pending do
      after(:create) { |u| u.roles.first&.update(state: 'pending') }
    end

    trait :policy_accepted do
      after(:create) { |u| u.roles.first&.update(state: 'policy_accepted') }
    end

    trait :profile_completed do
      after(:create) { |u| u.roles.first&.update(state: 'profile_completed') }
    end

    trait :active do
      after(:create) { |u| u.roles.first&.update(state: 'active') }
    end

    trait :disabled do
      after(:create) { |u| u.roles.first&.update(state: 'disabled') }
    end

    trait :rejected do
      after(:create) { |u| u.roles.first&.update(state: 'rejected') }
    end

    trait :screening_completed do
      after(:create) { |u| u.roles.first&.update(state: 'screening_completed') }
    end

    # TODO: weird trait, it should not return active disabled and rejected states
    trait :not_screening_completed do
      after(:create) do |u|
        u.roles.first&.update(state: %w[profile_completed active disabled rejected policy_accepted].sample)
      end
    end

    # Roles
    trait :staff do
      after(:create) do |user|
        user.add_role(:staff)
      end
    end

    trait :member do
      after(:create) do |user|
        user.add_role(:member)
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

    trait :mentor_or_member do
      after(:create) do |user|
        user.add_role(%i[mentor member].sample)
      end
    end

    trait :member_or_author do
      after(:create) do |user|
        user.add_role(%i[member author].sample)
      end
    end

    trait :mentor_or_author do
      after(:create) do |user|
        user.add_role(%i[mentor author].sample)
      end
    end

    trait :without_an_staff do
      after(:create) do |user|
        user.add_role(%i[mentor member author].sample)
      end
    end

    trait :without_an_member do
      after(:create) do |user|
        user.add_role(%i[staff mentor author].sample)
      end
    end

    trait :sample_role do
      after(:create) do |user|
        user.add_role(%i[staff mentor member author].sample)
      end
    end

    trait :with_idea do
      after(:create) do |user|
        create(:idea, author: user)
      end
    end

    trait :with_assignment do
      after(:create) do |user|
        create(:member_test_task_assignment, :uncompleted, member: user)
      end
    end

    trait :with_assignment_completed do
      after(:create) do |user|
        create(:member_test_task_assignment, :completed, member: user)
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
