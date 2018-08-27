# frozen_string_literal: true

# Allows only staff to manage users
class UserPolicy < DashboardPolicy
  def index?
    not_author?
  end

  alias show? index?

  def edit?
    staff?
  end

  alias update? edit?
  alias activate? edit?
  alias deactivate? edit?
  alias add_role? edit?
  alias remove_role? edit?
  alias manage_roles? edit?

  def approved?
    record.approver.present?
  end
end
