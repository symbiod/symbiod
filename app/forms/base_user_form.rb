# frozen_string_literal: true

# Validates common fields that are required for all users
# at all actions where they edit their profile
class BaseUserForm < BaseForm
  property :first_name
  property :last_name
  property :location
  property :timezone
  property :about

  validation do
    required(:first_name).filled
    required(:last_name).filled
    required(:timezone).filled
    required(:location).filled
    required(:about).value(:filled?, min_size?: 150)
  end
end
