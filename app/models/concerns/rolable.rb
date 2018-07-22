# This module provides a backward-compatible interface for the RolesManager class.
# It's goal is to prevent braking contract introduced by Rolify with existing code.
module Rolable
  extend ActiveSupport::Concern

  included do
    has_many :roles

    def self.with_role(name)
      User.joins(:roles).where(roles: { type: RolesManager.role_class_name(name) })
    end

    # We added this just for backward compatibility with Rolify
    def self.with_any_role(name)
      with_role(name)
    end
  end

  def self.role_class_names
    RolesManager.roles.map { |name| RolesManager.role_class_name(name) }
  end

  def has_role?(name)
    RolesManager.new(self).has?(name)
  end

  def add_role(name)
    RolesManager.new(self).add(name)
  end

  def remove_role(name)
    RolesManager.new(self).remove(name)
  end

  def roles_name
    self.roles.pluck(:type).map { |r| RolesManager.role_name_by_type(r) }
  end

  def role_class_name(name)
    RolesManager.role_class_name(name)
  end

  private

  # This class incapsulates all roles-related logic.
  # It handles complex convertion between human readable role `developer` and
  # its class name `Roles::Developer`, that is stored inside the AR STI models.
  class RolesManager
    ROLES_NAMESPACE = 'Roles::'
    MEMBER_ROLES = %w[developer mentor].freeze
    OTHER_ROLES = %w[staff author].freeze

    def self.roles
      [MEMBER_ROLES, OTHER_ROLES].flatten
    end

    # Returns class name for the specified role
    # e.g. `developer` => `Roles::Developer`
    def self.role_class_name(role)
      "#{ROLES_NAMESPACE}#{role.to_s.classify}"
    end

    # Returns humand readable role name by its class name
    # e.g. `Roles::Developer` => `developer`
    def self.role_name_by_type(role_class)
      role_class.to_s.demodulize.underscore
    end

    def initialize(user)
      @user = user
    end

    def add(name)
      return unless self.class.roles.include?(name.to_s)
      @user.roles.create!(type: RolesManager.role_class_name(name))
    end

    def remove(name)
      @user.roles.find_by(type: RolesManager.role_class_name(name)).delete
    end

    def has?(name)
      @user.roles.where(type: RolesManager.role_class_name(name)).count > 0
    end
  end
end
