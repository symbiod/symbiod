# frozen_string_literal: true

# Allows only staff to manage users
class UserPolicy < DashboardPolicy
  def index?
    true
  end

  def show?
    true
  end

  def activate?
    staff?
  end

  def deactivate?
    staff?
  end

  def add_role?
    staff?
  end

  def remove_role?
    staff?
  end
end
