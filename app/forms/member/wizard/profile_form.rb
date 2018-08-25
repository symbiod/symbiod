# frozen_string_literal: true

module Member
  class Wizard
    # Represents sign in wizard profile form.
    # Add `role` field as mandatory at this step.
    class ProfileForm < ::Member::BaseForm
      ROLES = %w[member mentor].freeze

      property :role, virtual: true

      validation do
        required(:role).value(included_in?: ROLES)
      end
    end
  end
end
