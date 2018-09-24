require 'rails_helper'

describe Web::Dashboard::ForceRoleActivationController do
  let(:performer) { create(:user, :staff) }
  let(:user) { create(:user, :member, :policy_accepted) }
  let(:role) { user.roles.last }

  before { login_user(performer) }

  describe 'PUT #update' do
    it 'calls ForceActivate operation' do
      expect(Ops::Roles::ForceActivate)
        .to receive(:call)
        .with(user: user, performer: performer)
      put :update, params: { id: role.id }
    end

    it 'redirects to user profile' do
      put :update, params: { id: role.id }
      expect(response).to redirect_to dashboard_user_url(user)
    end
  end
end
