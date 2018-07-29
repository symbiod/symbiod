# frozen_string_literal: true

# This module provides a backward-compatible interface for the RolesManager class.
# It's goal is to prevent breaking the contract introduced by Rolify with existing code.
module Rolable
  extend ActiveSupport::Concern

  included do
    has_many :roles

    def self.with_role(name)
      User.joins(:roles).where(roles: { type: Roles::RolesManager.role_class_name(name) })
    end

    # We added this just for backward compatibility with Rolify
    def self.with_any_role(name)
      with_role(name)
    end
  end

  def self.role_class_names
    Roles::RolesManager.roles.map { |name| Roles::RolesManager.role_class_name(name) }
  end

  def self.member_roles_class_names
    Roles::RolesManager::MEMBER_ROLES.map { |name| Roles::RolesManager.role_class_name(name) }
  end

  def has_role?(name) # rubocop:disable Naming/PredicateName
    Roles::RolesManager.new(self).has?(name)
  end

  def add_role(name)
    Roles::RolesManager.new(self).add(name)
  end

  def remove_role(name)
    Roles::RolesManager.new(self).remove(name)
  end

  def roles_name
    roles.pluck(:type).map { |r| Roles::RolesManager.role_name_by_type(r) }
  end

  def role_class_name(name)
    Roles::RolesManager.role_class_name(name)
  end
end
