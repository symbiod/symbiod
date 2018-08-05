# frozen_string_literal: true

module RolesHelper
  def role_for(user:, role_name:, **)
    ::Roles::RolesManager.new(user).role_for(role_name)
  end
end
