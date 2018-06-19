module Developer
  class UpdateUserForm < BaseForm
    property :email

    validation do
      required(:email).filled
    end
  end
end
