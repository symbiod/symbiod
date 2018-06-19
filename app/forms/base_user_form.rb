class BaseUserForm < BaseForm
  property :first_name
  property :last_name
  property :location
  property :timezone

  validation do
    required(:first_name).filled
    required(:last_name).filled
    required(:timezone).filled
    required(:location).filled
  end
end
