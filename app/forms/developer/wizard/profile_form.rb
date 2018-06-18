module Developer
  class Wizard
    class ProfileForm < BaseForm
      ROLES = %w[developer mentor].freeze

      property :first_name
      property :last_name
      property :location
      property :timezone
      property :cv_url
      property :role, virtual: true
      property :primary_skill_id, virtual: true

      validation do
        required(:first_name).filled
        required(:last_name).filled
        required(:location).filled
        required(:timezone).filled
        required(:cv_url).filled
        required(:role).value(included_in?: ROLES)
        required(:primary_skill_id).filled
      end
    end
  end
end
