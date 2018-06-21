# frozen_string_literal: true

module Author
  # Provides validations for author sign up
  # Allows us to extract validations from User model
  # since different roles in the system should have different
  # validations and required fields
  class RegistrationForm < BaseUserForm
    property :email
    property :password

    validation do
      required(:email).filled
      required(:password).filled
    end
  end
end
