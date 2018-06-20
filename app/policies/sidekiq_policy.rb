# frozen_string_literal: true

# Allows only staff to manage users
class SidekiqPolicy < ApplicationPolicy
  def access_allowed?
    user.has_role? :staff
  end
end
