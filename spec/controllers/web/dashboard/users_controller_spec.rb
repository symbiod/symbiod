# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Web::Dashboard::UsersController, type: :controller do
  let(:user) { create(:user, :staff) }

  describe 'GET #index' do
    context 'not signed in' do
      before { get :index }

      it 'redirect to root landing' do
        expect(response).to redirect_to '/'
      end
    end

    context 'not authorized' do
      let(:user) { create(:user, :active) }
      before { get :index }

      it 'redirect to dashboard root' do
        expect(response).to redirect_to dashboard_root_path
      end
    end

    context 'staff' do
      before { login_user(user) }
      before { get :index }

      it 'renders template' do
        expect(response).to render_template :index
      end

      it 'returns success status' do
        expect(response.status).to eq 200
      end
    end
  end

  describe 'GET #show' do
    context 'authorized' do
      let!(:candidate) { create(:user, :screening_completed) }
      before { login_user(user) }
      before { get :show, params: { id: candidate.id } }

      it 'renders template' do
        expect(response).to render_template :show
      end

      it 'returns success status' do
        expect(response.status).to eq 200
      end
    end

    context 'not authorized' do
      let!(:candidate) { create(:user, :active) }
      before { get :show, params: { id: user.id } }

      it 'redirect to dashboard root' do
        expect(response).to redirect_to dashboard_root_path
      end
    end
  end

  describe 'PUT #active' do
    context 'authorized' do
      let!(:candidate) { create(:user, :disable) }
      before { login_user(user) }

      it 'calls Activate operation' do
        expect(Ops::Developer::Activate).to receive(:call).with(user: candidate)
        put :activate, params: { id: candidate.id }
      end

      it 'redirect to users list' do
        put :activate, params: { id: candidate.id }
        expect(response).to redirect_to dashboard_users_path
      end

      it 'flash' do
        put :activate, params: { id: candidate.id }
        expect(flash[:success]).to be_present
      end
    end

    context 'not authorized' do
      let!(:candidate) { create(:user, :disable) }

      it 'redirect to dashboard root' do
        put :activate, params: { id: candidate.id }
        expect(response).to redirect_to dashboard_root_path
      end
    end
  end

  describe 'PUT #disable' do
    context 'authorized' do
      let!(:candidate) { create(:user, :active) }
      before { login_user(user) }

      it 'calls Activate operation' do
        expect(Ops::Developer::Disable).to receive(:call).with(user: candidate)
        put :disable, params: { id: candidate.id }
      end

      it 'redirect to users list' do
        put :disable, params: { id: candidate.id }
        expect(response).to redirect_to dashboard_users_path
      end
    end

    context 'not authorized' do
      let!(:candidate) { create(:user, :active) }

      it 'redirect to dashboard root' do
        put :disable, params: { id: candidate.id }
        expect(response).to redirect_to dashboard_root_path
      end
    end
  end

  describe 'PUT #add_role' do
    let(:role) { 'stuff' }
    context 'authorized' do
      let!(:candidate) { create(:user, :active) }
      before { login_user(user) }

      it 'calls Activate operation' do
        expect(Ops::Developer::AddRole).to receive(:call).with(user: candidate, role: role)
        put :add_role, params: { id: candidate.id, role: role }
      end

      it 'redirect to user' do
        put :add_role, params: { id: candidate.id, role: role }
        expect(response).to redirect_to dashboard_user_path(candidate)
      end
    end

    context 'not authorized' do
      let!(:candidate) { create(:user, :active) }

      it 'redirect to dashboard root' do
        put :add_role, params: { id: candidate.id, role: role }
        expect(response).to redirect_to dashboard_root_path
      end
    end
  end

  describe 'PUT #remove_role' do
    let(:role) { 'stuff' }
    context 'authorized' do
      let!(:candidate) { create(:user, :active, :staff) }
      before { login_user(user) }

      it 'calls Activate operation' do
        expect(Ops::Developer::RemoveRole).to receive(:call).with(user: candidate,
                                                                  role: role,
                                                                  size: candidate.roles.size)
        put :remove_role, params: { id: candidate.id, role: role }
      end

      it 'redirect to user' do
        put :remove_role, params: { id: candidate.id, role: role }
        expect(response).to redirect_to dashboard_user_path(candidate)
      end
    end

    context 'not authorized' do
      let!(:candidate) { create(:user, :active) }

      it 'redirect to dashboard root' do
        put :remove_role, params: { id: candidate.id, role: role }
        expect(response).to redirect_to dashboard_root_path
      end
    end
  end
end
