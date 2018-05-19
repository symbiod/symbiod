# frozen_string_literal: true

# Allows only stuff to manage newcomers applications
class DashboardPolicy < ApplicationPolicy
  def allowed?
    return false unless user
    user.active? || user.has_role?(:stuff)
  end

  private

  def stuff?
    user.has_role? :stuff
  end
end
