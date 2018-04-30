# frozen_string_literal: true

module Developer
  # Holds the results of onboarding steps.
  class Onboarding < ApplicationRecord
    belongs_to :user
  end
end
