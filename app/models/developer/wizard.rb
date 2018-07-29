# frozen_string_literal: true

module Developer
  # Keeps track of all wizard steps and allows to find
  # a path where user should be redirected to complete
  # current step
  class Wizard
    attr_reader :user

    def initialize(user)
      @user = user
    end

    def completed?
      !active?
    end

    def active?
      steps.include?(state)
    end

    def route_for_current_step
      steps_routes_mapping[state]
    end

    def steps
      steps_routes_mapping.keys
    end

    private

    def state
      ::Roles::RolesManager.new(user).role_for(:developer).state.to_sym
    end

    def steps_routes_mapping
      {
        pending: 'edit_bootcamp_wizard_accept_policy_url',
        policy_accepted: 'edit_bootcamp_wizard_profile_url',
        profile_completed: 'bootcamp_wizard_screenings_url',
        screening_completed: 'bootcamp_wizard_screenings_url'
      }
    end
  end
end
