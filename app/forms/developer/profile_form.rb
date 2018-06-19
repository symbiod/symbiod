module Developer
  class ProfileForm < BaseUserForm
    property :cv_url

    validation do
      required(:cv_url).filled
    end
  end
end
