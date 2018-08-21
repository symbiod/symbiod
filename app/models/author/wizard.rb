# frozen_string_literal: true

module Author
  # Keeps track of all wizard steps and allows to find
  # a path where user should be redirected to complete
  # current step
  class Wizard < BaseWizard
    def route_for_current_step
      steps_routes_mapping[state] || steps_routes_mapping[:guest]
    end

    private

    def role_name
      :author
    end

    def steps_routes_mapping
      {
        guest: 'new_idea_wizard_registrations_url',
        pending: 'edit_idea_wizard_policy_url',
        policy_accepted: 'idea_wizard_proposals_url',
        active: 'idea_wizard_proposals_url'
      }
    end
  end
end
