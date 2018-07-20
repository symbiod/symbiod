# frozen_string_literal: true

# Method to redering date registration of user
# in view "DD-MM-YYY"
module DateHelper
  def reg_date(user)
    user.created_at.strftime("%d-%m-%Y")
  end
end
