module Bootcamp
  class LoginForm < Reform::Form
    property :email
    property :password

    validation do
      required(:email).filled
      required(:password).filled
    end
  end
end
