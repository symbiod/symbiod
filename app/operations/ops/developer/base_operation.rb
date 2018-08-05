# frozen_string_literal: true

module Ops
  module Developer
    # Handles common functionality, used for for developer/mentor roles
    class BaseOperation < ::Ops::BaseOperation
      # We do this trick, to differenciate developer and mentor
      # since they both reuse the same operations for screening and
      # onboarding
      # NOTICE: Keep in mind, that it can break, if developer will also have a
      # mentor role.
      def role(user)
        role_for(user: user, role_name: :developer) ||
          role_for(user: user, role_name: :mentor)
      end

      private

      def role_for(user:, role_name:, **)
        Roles::RolesManager.new(user).role_for(role_name)
      end
    end
  end
end
