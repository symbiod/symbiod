# frozen_string_literal: true

module Member
  # Contains additional fields, that can be updated by staff.
  class UpdateUserForm < ::Member::BaseForm
    property :email
    property :github

    validation do
      required(:email).filled
      required(:github).filled
    end
  end
end
