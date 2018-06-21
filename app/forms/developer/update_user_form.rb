# frozen_string_literal: true

module Developer
  # Contains additional fields, that can be updated by staff.
  class UpdateUserForm < ::Developer::BaseForm
    property :email
    property :github

    validation do
      required(:email).filled
      required(:github).filled
    end
  end
end
