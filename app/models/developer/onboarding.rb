# frozen_string_literal: true

module Developer
  # Holds the results of onboarding steps.
  class Onboarding < ApplicationRecord
    self.ignored_columns = %w[github slack]

    COUNT_TASKS = 3

    belongs_to :user
  end
end
