# frozen_string_literal: true

require 'rails_helper'

describe Web::Dashboard::RoleDeactivationController, type: :controller do
  describe 'PUT #update' do
    let(:role) { create(:role, :member, :active) }

    context 'not signed in' do
      let(:user) { create(:user, :staff, :active) }
      before { put :update, params: { id: role.id } }

      it 'redirects to root landing' do
        expect(response).to redirect_to root_landing_url
      end
    end

    context 'signed in' do
      before { login_user(user) }

      context 'user has role staff or mentor' do
        let(:user) { create(:user, :staff_or_mentor, :active) }

        it 'call operation activate role' do
          expect(Ops::Roles::Deactivate).to receive(:call).with(role: role)
          put :update, params: { id: role.id }
        end

        it 'redirects to user page' do
          put :update, params: { id: role.id }
          expect(response).to redirect_to dashboard_user_url(role.user)
        end
      end

      context 'user has role member or author' do
        let(:user) { create(:user, :member_or_author, :active) }

        it 'redirects to dashboard root' do
          put :update, params: { id: role.id }
          expect(response).to redirect_to dashboard_root_url
        end
      end
    end
  end
end
