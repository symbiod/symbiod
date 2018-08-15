# frozen_string_literal: true

# Base class for Author/Member wizards,
# that provides interface for tracking the current
# or next step of sign up.
class BaseWizard
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def completed?
    !active?
  end

  def active?
    steps.include?(state) || state.nil?
  end

  # When the user has just signed up, he may not have a role and state
  # for this case we redirect him to the very first step
  def route_for_current_step
    steps_routes_mapping[state] || steps_routes_mapping[:pending]
  end

  def steps
    steps_routes_mapping.keys
  end

  def state
    ::Roles::RolesManager.new(user).role_for(role_name)&.state&.to_sym
  end

  private

  def role_name
    raise 'Implement in child class'
  end

  def steps_routes_mapping
    raise 'Implement in child class'
  end
end
