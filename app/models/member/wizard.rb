# frozen_string_literal: true

module Member
  # Keeps track of all wizard steps and allows to find
  # a path where user should be redirected to complete
  # current step
  class Wizard < BaseWizard
    private

    def role_name
      :member
    end

    def steps_routes_mapping
      {
        pending: 'edit_bootcamp_wizard_profile_url',
        profile_completed: 'edit_bootcamp_wizard_accept_policy_url',
        policy_accepted: 'bootcamp_wizard_screenings_url',
        screening_completed: 'bootcamp_wizard_screenings_url'
      }
    end
  end
end
