# frozen_string_literal: true

module Roles
  # This class incapsulates all roles-related logic.
  # It handles complex convertion between human readable role `developer` and
  # its class name `Roles::Developer`, that is stored inside the AR STI models.
  # TODO: maybe rename it to the repository?
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

      role_class = RolesManager.role_class_name(name)
      return if @user.roles.find_by(type: role_class)

      @user.roles.create!(type: role_class)
    end

    def remove(name)
      @user.roles.where(type: RolesManager.role_class_name(name)).delete_all
    end

    def has?(name)
      @user.roles.where(type: RolesManager.role_class_name(name)).count.positive?
    end

    def role_for(name)
      @user.roles.find_by(type: RolesManager.role_class_name(name))
    end
  end
end
