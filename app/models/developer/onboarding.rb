# frozen_string_literal: true

module Developer
  # Holds the results of onboarding steps.
  class Onboarding < ApplicationRecord
    self.ignored_columns = %w[github slack]

    include AASM

    COUNT_TASKS = 3

    belongs_to :user

    aasm :github, column: 'github_status' do
      state :github_pending, initial: true
      state :github_invited, :github_joined, :github_left

      event :github_invite do
        transitions from: :github_pending, to: :github_invited
      end

      event :github_join do
        transitions from: :github_invited, to: :github_joined
      end

      event :github_left do
        transitions from: :github_joined, to: :github_left
      end
    end

    aasm :slack, column: 'slack_status' do
      state :slack_pending, initial: true
      state :slack_invited, :slack_joined, :slack_left

      event :slack_invite do
        transitions from: :slack_pending, to: :slack_invited
      end

      event :slack_join do
        transitions from: :slack_invited, to: :slack_joined
      end

      event :slack_left do
        transitions from: :slack_joined, to: :slack_left
      end
    end

    aasm :feedback, column: 'feedback_status' do
      state :feedback_pending, initial: true
      state :feedback_completed

      event :feedback_complete do
        transitions from: :feedback_pending, to: :feedback_completed
      end
    end
  end
end
