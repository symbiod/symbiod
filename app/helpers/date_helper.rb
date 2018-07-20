# frozen_string_literal: true

# Method to redering date registration of user
module DateHelper
  def human_date(user)
    user.created_at.strftime('%d-%m-%Y')
  end
end
