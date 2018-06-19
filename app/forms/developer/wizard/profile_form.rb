module Developer
  class Wizard
    class ProfileForm < ::Developer::BaseForm
      ROLES = %w[developer mentor].freeze

      property :role, virtual: true

      validation do
        required(:role).value(included_in?: ROLES)
      end
    end
  end
end
