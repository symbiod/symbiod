module Developer
  class UpdateUserForm < ::Developer::BaseForm
    property :email
    property :github

    validation do
      required(:email).filled
      required(:github).filled
    end
  end
end
