module Rolable
  extend ActiveSupport::Concern

  ROLES_NAMESPACE = 'Roles::'

  included do
    has_many :roles

    def self.with_role(name)
      User.joins(:roles).where(roles: { type: "#{ROLES_NAMESPACE}#{name.to_s.classify}" })
    end

    def self.with_any_role(name)
      User.joins(:roles).where(roles: { type: "#{ROLES_NAMESPACE}#{name.to_s.classify}" })
    end
  end

  def has_role?(name)
    roles.where(type: role_class_name(name)).count > 0
  end

  def add_role(name)
    return unless Rolable.roles.include?(name.to_s)
    roles.create!(type: role_class_name(name))
  end

  def remove_role(name)
    roles.where(type: role_class_name(name)).delete_all
  end

  def roles_name
    roles.pluck(:type).map { |r| r.demodulize.underscore }
  end

  def self.member_roles
    %w[developer mentor]
  end

  def self.other_roles
    %w[staff author]
  end

  def self.roles
    member_roles + other_roles
  end

  def self.for_test_tasks
    member_roles
  end

  def self.role_class_names
    roles.map { |name| "#{ROLES_NAMESPACE}#{name.to_s.classify}" }
  end

  def role_class_name(name)
    "#{ROLES_NAMESPACE}#{name.to_s.classify}"
  end

  private

  class RolesManager
    def initialize(user, role_name)
      @user      = user
      @role_name = role_name
    end

  end
end
