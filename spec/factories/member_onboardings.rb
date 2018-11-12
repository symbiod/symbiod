# frozen_string_literal: true

FactoryBot.define do
  factory :member_onboarding, class: 'Member::Onboarding' do
    user
    slack_status 'slack_pending'
    github_status 'github_pending'
    feedback_status 'feedback_pending'
    onboarding_complete_date_at Time.current

    trait :invited_to_slack do
      slack_status 'slack_invited'
    end

    trait :joined_to_slack do
      slack_status 'slack_joined'
    end

    trait :left_slack do
      slack_status 'slack_left'
    end

    trait :invited_to_github do
      github_status 'github_invited'
    end

    trait :joined_to_github do
      github_status 'github_joined'
    end

    trait :left_github do
      github_status 'github_left'
    end

    trait :feedback_completed do
      feedback_status 'feedback_completed'
    end
  end
end
