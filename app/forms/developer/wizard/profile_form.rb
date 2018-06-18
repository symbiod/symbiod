module Developer
  module Wizard
    class ProfileForm < BaseForm
      property :first_name
      property :last_name
      property :location
      property :timezone
      property :cv_url
      property :role
      property :primary_skill_id

      validation do
        required(:first_name).filled
        required(:last_name).filled
        required(:location).filled
        required(:timezone).filled
        required(:cv_url).filled
        required(:role).filled
        required(:primary_skill_id).filled
      end
    end
  end
end
