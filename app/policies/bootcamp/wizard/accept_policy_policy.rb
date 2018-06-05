# frozen_string_literal: true

module Bootcamp
  module Wizard
    # Defines access rules to profile editing wizard page
    class AcceptPolicyPolicy < ApplicationPolicy
      def edit?
        user&.pending?
      end
    end
  end
end
