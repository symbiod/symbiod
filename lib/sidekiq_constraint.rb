# frozen_string_literal: true

# Allows only users with role `staff` to access sidekiq dashboard
class SidekiqConstraint
  def matches?(request)
    return false unless User.exists?(request.session[:user_id])
    user = User.find request.session[:user_id]
    SidekiqPolicy.new(user, nil).access_allowed?
  end
end
