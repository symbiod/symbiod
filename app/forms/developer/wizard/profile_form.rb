# frozen_string_literal: true

module Developer
  class Wizard
    # Represents sign in wizard profile form.
    # Add `role` field as mandatory at this step.
    class ProfileForm < ::Developer::BaseForm
      ROLES = %w[developer mentor].freeze

      property :role, virtual: true

      validation do
        required(:role).value(included_in?: ROLES)
      end
    end
  end
end
