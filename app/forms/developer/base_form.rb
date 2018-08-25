# frozen_string_literal: true

module Member
  # Contains additional fields, that are required for member
  # We do not use it directly anywhere, just inherit specific forms
  # from this one
  class BaseForm < BaseUserForm
    property :cv_url
    property :primary_skill_id, virtual: true

    validation do
      required(:cv_url).filled
      required(:primary_skill_id).filled
    end
  end
end
