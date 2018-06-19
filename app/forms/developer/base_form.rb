module Developer
  class BaseForm < BaseUserForm
    property :cv_url
    property :primary_skill_id, virtual: true

    validation do
      required(:cv_url).filled
      required(:primary_skill_id).filled
    end
  end
end
