# frozen_string_literal: true

# Allows only users with role `stuff` to access sidekiq dashboard
class SidekiqConstraint
  def matches?(request)
    return false unless request.session[:user_id]
    user = User.find request.session[:user_id]
    user&.has_role?(:stuff)
  end
end
