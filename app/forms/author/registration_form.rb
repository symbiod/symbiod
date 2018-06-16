# frozen_string_literal: true

module Author
  # Provides validations for author sign up
  # Allows us to extract validations from User model
  # since different roles in the system should have different
  # validations and required fields
  class RegistrationForm < BaseForm
    property :email
    property :first_name
    property :last_name
    property :timezone
    property :location
    property :password

    validation do
      required(:email).filled
      required(:first_name).filled
      required(:last_name).filled
      required(:timezone).filled
      required(:location).filled
      required(:password).filled
    end
  end
end
