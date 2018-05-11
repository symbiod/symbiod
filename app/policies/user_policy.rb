# frozen_string_literal: true

# Allows only stuff to manage users
class UserPolicy < DashboardPolicy
  def index?
    true
  end

  def show?
    true
  end

  def activate?
    stuff?
  end

  def delete?
    stuff?
  end

  def add_role?
    stuff?
  end

  def delete_role?
    stuff?
  end
end
