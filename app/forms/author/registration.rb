module Author
  class Registration < BaseForm
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
