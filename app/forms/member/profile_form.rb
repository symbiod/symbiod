# frozen_string_literal: true

module Member
  # Add fields that can be updated by user at his dashboard profile.
  class ProfileForm < BaseUserForm
    property :cv_url

    validation do
      required(:cv_url).filled
    end
  end
end
