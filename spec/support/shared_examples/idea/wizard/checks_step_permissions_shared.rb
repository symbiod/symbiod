# frozen_string_literal: true

require 'rails_helper'

# This shared examples allow to reuse specs of authorization
# at wizard step controllers.
# Each controller should redirect user to a proper step,
# if its state does not correlate with current controller.
# Similar shared examples exist for bootcamp controllers namespace.
# TODO: think how can we reuse them?
RSpec.shared_examples 'checks step permissions for author' do
  context 'user state mismatches the step' do
    it 'redirects to proper step' do
      invoke_action
      path_helper = Author::Wizard.new(user).route_for_current_step
      expect(response).to redirect_to public_send(path_helper)
    end
  end

  context 'user is active' do
    let(:user) { create(:user, :author, :active) }

    it 'redirects to proper step' do
      invoke_action
      expect(response).to redirect_to idea_wizard_proposals_url
    end
  end
end
