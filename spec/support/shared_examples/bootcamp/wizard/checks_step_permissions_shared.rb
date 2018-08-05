# frozen_string_literal: true

require 'rails_helper'

# This shared examples allow to reuse specs of authorization
# at wizard step controllers.
# Each controller should redirect user to a proper step,
# if its state does not correlate with current controller.
RSpec.shared_examples 'checks step permissions' do
  context 'user state mismatches the step' do
    let(:user) { create(:user, :developer, :with_assignment, wrong_state) }

    it 'redirects to proper step' do
      invoke_action
      path_helper = Developer::Wizard.new(user).route_for_current_step
      expect(response).to redirect_to public_send(path_helper)
    end
  end

  context 'user is active' do
    let(:user) { create(:user, :developer, :with_assignment, :active) }

    it 'redirects to proper step' do
      invoke_action
      expect(response).to redirect_to bootcamp_root_url
    end
  end
end
