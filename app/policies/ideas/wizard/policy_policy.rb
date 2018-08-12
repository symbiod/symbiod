# frozen_string_literal: true

module Ideas
  module Wizard
    class PolicyPolicy < ApplicationPolicy
      def authorized?
        Author::Wizard.new(user).state == :pending
      end
    end
  end
end
