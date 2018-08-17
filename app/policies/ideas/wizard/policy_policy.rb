# frozen_string_literal: true

module Ideas
  module Wizard
    # Defines rules for access policy page on author signup
    class PolicyPolicy < ApplicationPolicy
      def authorized?
        Author::Wizard.new(user).state == :pending
      end
    end
  end
end
